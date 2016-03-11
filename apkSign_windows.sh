#! /bin/bash
project_home=/d/mygit/ebiz-mobile
zipalign=C:\Users\dingyuan\AppData\Local\Android\sdk\build-tools\23.0.2\zipalign.exe


echo $project_home
echo $zipalign

cd $project_home
echo "pls select platforms:ios or android"
read platform
if [ $platform = android ] || [ $platform = ios ];
then
echo "building $platform";
else
echo "platform is invalid!";
exit
fi

echo "pls select target :scdev(四川测试版本) scprod(四川生产版本）jsdev（江苏测试版本） jsprod(江苏生产版本)"
read target
echo "starting to build $target $platform"
debug_release=debug
case $target in scdev|jsdev)
debug_release=debug;;
scprod|jsprod)
debug_release=release;;
*)
echo "target version invalid"
exit
esac

echo "pls input 版本号："
read version


echo "target=$target ebizVersion=$version ionic build $platform --$debug_release"
target=$target ebizVersion=$version ionic build $platform --$debug_release


cd `dirname $0`
rm -f *.apk

if [ $platform = android ];
then
  if [ $debug_release = release ];
  then
  cp $project_home/platforms/android/build/outputs/apk/android-release-unsigned.apk ./
  jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore youbangeabcmobile android-release-unsigned.apk youbang
  $zipalign -v   4   android-release-unsigned.apk   EABCMobile$version.apk
  else
  cp $project_home/platforms/android/build/outputs/apk/android-debug.apk ./
  fi
fi
echo $platform $target $version $debug_release
exit