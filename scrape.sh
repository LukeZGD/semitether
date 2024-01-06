#!/bin/bash
#set -x
devices=(iPad2,1 iPad2,2 iPad2,3)

cd "$(dirname "$0")"

dir="bin/macos"
jq="$dir/jq"
pzb="$dir/pzb"
xpwntool="$dir/xpwntool"
bsdiff="$dir/bsdiff"
make_kernel_patchfile="$dir/make_kernel_patchfile"
apply_patchfile="$dir/apply_patchfile"
mkdir kernelcaches kernelcaches_dec kernelcaches_patched patches 2>/dev/null

for device in ${devices[@]}; do
    echo $device
    json=$(curl "https://firmware-keys.ipsw.me/device/$device")
    case $device in
        iPad2,1 ) device_model=K93;;
        iPad2,2 ) device_model=K94;;
        iPad2,3 ) device_model=K95;;
    esac

    case $device in
        iPad2,1 ) device_modell=k93;;
        iPad2,2 ) device_modell=k94;;
        iPad2,3 ) device_modell=k95;;
    esac

    len=$(echo "$json" | $jq length)
    builds=()
    i=0
    while (( i < len )); do
        j=$(echo "$json" | $jq -r ".[$i].buildid")
        if [[ $j == "8"* ]]; then
            builds+=("$j")
        fi
        ((i++))
    done

    for build in ${builds[@]}; do
        echo ${device_model}_${build}
        url="$(curl https://api.ipsw.me/v2.1/$device/$build/url)"
        $pzb -g "kernelcache.release.$device_modell" -o "kc-${device_model}_${build}" "$url"
        mv "kc-${device_model}_${build}" kernelcaches/

        case $build in
            8F191 ) vers=4.3;;
            8G4   ) vers=4.3.1;;
            8H*   ) vers=4.3.2;;
            8J2   ) vers=4.3.3;;
            8K2   ) vers=4.3.4;;
            8L1   ) vers=4.3.5;;
        esac

        device_fw_key="$(curl https://api.m1sta.xyz/wikiproxy/$device/$build)"
        iv=$(echo $device_fw_key | $jq -j '.keys[] | select(.image | startswith("Kernelcache")) | .iv')
        key=$(echo $device_fw_key | $jq -j '.keys[] | select(.image | startswith("Kernelcache")) | .key')
        echo "xpwntool kernelcaches/kc-${device_model}_${build} kernelcaches_dec/kc-${device_model}_${build}.dec -iv $iv -k $key"
        $xpwntool kernelcaches/kc-${device_model}_${build} kernelcaches_dec/kc-${device_model}_${build}.dec -iv $iv -k $key

        rm patchfile 2>/dev/null
        $make_kernel_patchfile kernelcaches_dec/kc-${device_model}_${build}.dec patchfile
        $apply_patchfile kernelcaches_dec/kc-${device_model}_${build}.dec patchfile kernelcaches_patched/kc-${device_model}_${build}.patched
        $bsdiff kernelcaches_dec/kc-${device_model}_${build}.dec kernelcaches_patched/kc-${device_model}_${build}.patched patches/kernelcache.release.$device_modell.$build.patch
    done
done
