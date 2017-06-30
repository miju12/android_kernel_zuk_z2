#!/bin/bash
kernel_version=${1}
kernel_name="Noog-CAF"
device_name="Z2"
zip_name="$kernel_name-$device_name-$kernel_version.zip"

export CONFIG_FILE="noog-caf_z2_plus_defconfig"
export ARCH="arm64"
export KBUILD_BUILD_USER="Lemoncè"
export KBUILD_BUILD_HOST="DD3Boh"
export TOOL_CHAIN_PATH="${HOME}/kernel/aarch64-linux-gnu-linaro-7.x"
export CROSS_COMPILE=$TOOLCHAIN_PATH/bin/aarch64-linux-gnu-
export CONFIG_ABS_PATH="arch/${ARCH}/configs/${CONFIG_FILE}"
export objdir="${HOME}/kernel/zuk/obj"
export sourcedir="${HOME}/kernel/zuk/noog-caf"
export anykernel="${HOME}/kernel/zuk/anykernel"
compile() {
  make O=$objdir ARCH=arm64  $CONFIG_FILE -j24
  make O=$objdir -j24
}
module_stock(){
  rm -rf $anykernel/modules/
  mkdir $anykernel/modules
  find $objdir -name '*.ko' -exec cp -av {} $anykernel/modules/ \;
  # strip modules
  ${CROSS_COMPILE}strip --strip-unneeded $anykernel/modules/*
  cp -rf $objdir/arch/arm64/boot/Image.gz-dtb $anykernel/zImage
}
delete_zip(){
  cd $anykernel
  find . -name "*.zip" -type f
  find . -name "*.zip" -type f -delete
}
build_package(){
  zip -r9 UPDATE-AnyKernel2.zip * -x README UPDATE-AnyKernel2.zip
}
make_name(){
  mv UPDATE-AnyKernel2.zip $zip_name
}
turn_back(){
cd $sourcedir
}
compile
module_stock
delete_zip
build_package
make_name
turn_back
