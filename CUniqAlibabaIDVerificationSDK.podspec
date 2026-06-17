Pod::Spec.new do |s|
  s.name = 'CUniqAlibabaIDVerificationSDK'
  s.version = '1.0.4'
  s.summary = 'Alibaba ID Verification binary SDK for CUnique UTS plugin'
  s.description = 'Vendored Alibaba ID Verification frameworks and resource bundles used by the CUnique UTS plugin.'
  s.homepage = 'https://github.com/shendsh2026/CUniqAlibabaIDVerificationSDK'
  s.license = { :type => 'Commercial' }
  s.author = { 'CUniq' => 'dev@example.com' }

  s.platform = :ios, '13.0'
  s.source = {
    :git => 'https://github.com/shendsh2026/CUniqAlibabaIDVerificationSDK.git',
    :tag => s.version.to_s
  }

  s.ios.vendored_frameworks = [
    'Frameworks/AliyunIdentityPlatform.framework',
    'Frameworks/AliyunIdentityFace.framework',
    'Frameworks/AliyunIdentityOcr.framework',
    'Frameworks/AliyunIdentityNFC.framework',
    'Frameworks/AliyunIdentityUtils.framework',
    'Frameworks/AliyunOSSiOS.framework',
    'Frameworks/IDVMNN.framework',
    'Frameworks/OpenSSL.framework',
    'Frameworks/faceguard.framework'
  ]

  s.ios.resources = [
    'Resources/*.bundle',
    'Frameworks/**/*.bundle'
  ]

  s.script_phase = {
    :name => 'Copy Alibaba ID Verification Resource Bundles',
    :execution_position => :after_compile,
    :script => <<-SCRIPT
set -e

RESOURCE_ROOT="${PODS_TARGET_SRCROOT}/Resources"
if [ ! -d "${RESOURCE_ROOT}" ]; then
  echo "[CUniqAlibabaIDVerificationSDK] Resource root not found: ${RESOURCE_ROOT}"
  exit 0
fi

copy_bundles() {
  destination="$1"
  if [ -z "${destination}" ]; then
    return 0
  fi
  mkdir -p "${destination}"
  for bundle in "${RESOURCE_ROOT}"/AliyunIdentity*.bundle; do
    if [ -d "${bundle}" ]; then
      echo "[CUniqAlibabaIDVerificationSDK] Copy $(basename "${bundle}") to ${destination}"
      rsync -a --delete "${bundle}" "${destination}/"
    fi
  done
}

copy_if_dir() {
  destination="$1"
  if [ -d "${destination}" ]; then
    copy_bundles "${destination}"
  fi
}

copy_if_dir "${TARGET_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
copy_if_dir "${BUILT_PRODUCTS_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"
copy_if_dir "${CONFIGURATION_BUILD_DIR}/${UNLOCALIZED_RESOURCES_FOLDER_PATH}"

for app in "${TARGET_BUILD_DIR}"/*.app "${BUILT_PRODUCTS_DIR}"/*.app "${CONFIGURATION_BUILD_DIR}"/*.app; do
  copy_if_dir "${app}"
done

for base in "${TARGET_BUILD_DIR}" "${BUILT_PRODUCTS_DIR}" "${CONFIGURATION_BUILD_DIR}"; do
  if [ -d "${base}" ]; then
    find "${base}" -maxdepth 5 -type d \\( -name 'unimodule*.framework' -o -name 'CUniqAlibabaIDVerificationSDK.framework' \\) -print | while read framework_dir; do
      copy_bundles "${framework_dir}"
    done
  fi
done
    SCRIPT
  }

  s.preserve_paths = [
    'Frameworks/**/*.framework',
    'Resources/*.bundle'
  ]

  s.frameworks = [
    'AudioToolbox',
    'CoreML',
    'Accelerate',
    'AVFoundation',
    'CoreTelephony',
    'SystemConfiguration',
    'UIKit',
    'Foundation',
    'WebKit',
    'CoreMotion',
    'CoreMedia',
    'CoreVideo',
    'CoreNFC',
    'CryptoKit',
    'CryptoTokenKit',
    'Security'
  ]

  s.libraries = [
    'c++',
    'z',
    'resolv',
    'sqlite3'
  ]

  s.user_target_xcconfig = {
    'OTHER_LDFLAGS' => '$(inherited) -Wl,-multiply_defined,suppress'
  }

  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '$(inherited) -Wl,-multiply_defined,suppress'
  }
end
