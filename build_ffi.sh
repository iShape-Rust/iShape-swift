#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FFI_DIR="${ROOT_DIR}/iShape-ffi"
SWIFT_LIB_DIR="${ROOT_DIR}/iShape-swift/Sources/iShapeFFI/lib"
MAC_DIR="${SWIFT_LIB_DIR}/macos"
IOS_DEVICE_DIR="${SWIFT_LIB_DIR}/ios/device"
IOS_SIM_DIR="${SWIFT_LIB_DIR}/ios/simulator"

mkdir -p "${MAC_DIR}" "${IOS_DEVICE_DIR}" "${IOS_SIM_DIR}"

MAC_TARGETS=(
    "aarch64-apple-darwin"
    "x86_64-apple-darwin"
)

IOS_DEVICE_TARGETS=(
    "aarch64-apple-ios"
)

IOS_SIM_TARGETS=(
    "aarch64-apple-ios-sim"
    "x86_64-apple-ios"
)

build_targets() {
    local targets=("$@")
    for target in "${targets[@]}"; do
        if ! rustup target list --installed | grep -q "^${target}$"; then
            echo "Installing missing Rust target: ${target}"
            rustup target add "${target}"
        fi

        echo "Building i_shape_ffi for ${target}..."
        cargo build \
            --manifest-path "${FFI_DIR}/Cargo.toml" \
            --release \
            --target "${target}"
    done
}

build_targets "${MAC_TARGETS[@]}"
build_targets "${IOS_DEVICE_TARGETS[@]}"
build_targets "${IOS_SIM_TARGETS[@]}"

LIB_ARM64_MAC="${FFI_DIR}/target/aarch64-apple-darwin/release/libi_shape_ffi.a"
LIB_X86_MAC="${FFI_DIR}/target/x86_64-apple-darwin/release/libi_shape_ffi.a"
MAC_OUTPUT_LIB="${MAC_DIR}/libi_shape_ffi.a"

if command -v lipo >/dev/null 2>&1 && [[ -f "${LIB_ARM64_MAC}" && -f "${LIB_X86_MAC}" ]]; then
    echo "Creating universal macOS static library..."
    lipo -create -output "${MAC_OUTPUT_LIB}" "${LIB_ARM64_MAC}" "${LIB_X86_MAC}"
else
    echo "lipo not available or one architecture missing; copying available macOS build."
    if [[ -f "${LIB_ARM64_MAC}" ]]; then
        cp "${LIB_ARM64_MAC}" "${MAC_OUTPUT_LIB}"
    elif [[ -f "${LIB_X86_MAC}" ]]; then
        cp "${LIB_X86_MAC}" "${MAC_OUTPUT_LIB}"
    else
        echo "Error: no macOS library found." >&2
        exit 1
    fi
fi

echo "macOS library placed at ${MAC_OUTPUT_LIB}"

LIB_IOS_DEVICE="${FFI_DIR}/target/aarch64-apple-ios/release/libi_shape_ffi.a"
IOS_DEVICE_OUTPUT="${IOS_DEVICE_DIR}/libi_shape_ffi.a"

if [[ -f "${LIB_IOS_DEVICE}" ]]; then
    cp "${LIB_IOS_DEVICE}" "${IOS_DEVICE_OUTPUT}"
    echo "iOS device library placed at ${IOS_DEVICE_OUTPUT}"
else
    echo "Warning: iOS device library not found at ${LIB_IOS_DEVICE}" >&2
fi

LIB_ARM64_IOS_SIM="${FFI_DIR}/target/aarch64-apple-ios-sim/release/libi_shape_ffi.a"
LIB_X86_IOS_SIM="${FFI_DIR}/target/x86_64-apple-ios/release/libi_shape_ffi.a"
IOS_SIM_OUTPUT="${IOS_SIM_DIR}/libi_shape_ffi.a"

if command -v lipo >/dev/null 2>&1 && [[ -f "${LIB_ARM64_IOS_SIM}" && -f "${LIB_X86_IOS_SIM}" ]]; then
    echo "Creating universal iOS simulator static library..."
    lipo -create -output "${IOS_SIM_OUTPUT}" "${LIB_ARM64_IOS_SIM}" "${LIB_X86_IOS_SIM}"
elif [[ -f "${LIB_ARM64_IOS_SIM}" ]]; then
    echo "Using arm64 iOS simulator build."
    cp "${LIB_ARM64_IOS_SIM}" "${IOS_SIM_OUTPUT}"
elif [[ -f "${LIB_X86_IOS_SIM}" ]]; then
    echo "Using x86_64 iOS simulator build."
    cp "${LIB_X86_IOS_SIM}" "${IOS_SIM_OUTPUT}"
else
    echo "Warning: no iOS simulator library found." >&2
fi

echo "Done."
