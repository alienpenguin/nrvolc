#include "NrVolumeChangerMac.h"
#include "cocoaHelper.h"

#import <AppKit/NSSound.h>
#import <AudioToolbox/AudioServices.h>

#include <QDebug>
#include <QtMacExtras>



NrVolumeChangerMacImpl::NrVolumeChangerMacImpl(QObject *p) :
    NrVolumeChanger(p)
{

}


int NrVolumeChangerMacImpl::getDefaultInputDeviceId() const
{
    int devid = -1;
    AudioObjectPropertyAddress propertyDefaultInput = {
        kAudioHardwarePropertyDefaultInputDevice,
        kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };

    //get DefaultAudioOutput Id
    UInt32 defaultOutputDeviceIDSize = sizeof(UInt32), defaultOutputDeviceID;
    OSStatus ret = AudioObjectGetPropertyData(
                AudioObjectID(kAudioObjectSystemObject),
                &propertyDefaultInput,
                0,
                nil,
                &defaultOutputDeviceIDSize,
                &defaultOutputDeviceID);
    qDebug() << "getting default input device id" << ret << defaultOutputDeviceID;
    devid = defaultOutputDeviceID;
    return devid;
}


int NrVolumeChangerMacImpl::getDefaultOutputDeviceId() const
{
    int devid = -1;
    AudioObjectPropertyAddress propertyDefaultOutput = {
        kAudioHardwarePropertyDefaultOutputDevice,
        kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };

    //get DefaultAudioOutput Id
    UInt32 defaultOutputDeviceIDSize = sizeof(UInt32), defaultOutputDeviceID;
    OSStatus ret = AudioObjectGetPropertyData(
                AudioObjectID(kAudioObjectSystemObject),
                &propertyDefaultOutput,
                0,
                nil,
                &defaultOutputDeviceIDSize,
                &defaultOutputDeviceID);
    qDebug() << "getting default output device id" << ret << defaultOutputDeviceID;
    devid = defaultOutputDeviceID;
    return devid;
}


int NrVolumeChangerMacImpl::setVolume(double percent)
{

    Float32 outPropertyData = 0.0;
    OSStatus ret;

//    AudioObjectPropertyAddress propertyDefaultOutput = {
//        kAudioHardwarePropertyDefaultOutputDevice,
//        kAudioDevicePropertyScopeOutput,
//        kAudioObjectPropertyElementMaster
//    };

//    //get DefaultAudioOutput Id
//    UInt32 defaultOutputDeviceIDSize = sizeof(UInt32), defaultOutputDeviceID;
//    ret = AudioObjectGetPropertyData(
//                AudioObjectID(kAudioObjectSystemObject),
//                &propertyDefaultOutput,
//                0,
//                nil,
//                &defaultOutputDeviceIDSize,
//                &defaultOutputDeviceID);
//    qDebug() << ret << defaultOutputDeviceID;

    UInt32 defaultOutputDeviceID = getDefaultOutputDeviceId();

    AudioObjectPropertyAddress propertyAddress = {
        kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
        kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };


    //Set DefaultAudioOutput volume
    outPropertyData = percent/100.0;
    ret = AudioHardwareServiceSetPropertyData(defaultOutputDeviceID,
                                        &propertyAddress,
                                        0,
                                        NULL,
                                        sizeof(Float32),
                                        &outPropertyData);

    qDebug() << ret << outPropertyData;
    return 0;
}


double NrVolumeChangerMacImpl::getVolume() const
{
    Float32 outPropertyData = 0;
    UInt32 outPropertyDataSize = sizeof(Float32);
    OSStatus ret;

//    AudioObjectPropertyAddress propertyDefaultOutput = {
//        kAudioHardwarePropertyDefaultOutputDevice,
//        kAudioDevicePropertyScopeOutput,
//        kAudioObjectPropertyElementMaster
//    };

//    //get DefaultAudioOutput Id
//    UInt32 defaultOutputDeviceIDSize = sizeof(UInt32), defaultOutputDeviceID;
//    ret = AudioObjectGetPropertyData(
//                AudioObjectID(kAudioObjectSystemObject),
//                &propertyDefaultOutput,
//                0,
//                nil,
//                &defaultOutputDeviceIDSize,
//                &defaultOutputDeviceID);
//    qDebug() << "output device id" << ret << defaultOutputDeviceID;

    UInt32 defaultOutputDeviceID = getDefaultOutputDeviceId();


    AudioObjectPropertyAddress propertyAddress = {
        kAudioHardwareServiceDeviceProperty_VirtualMasterVolume,
        kAudioDevicePropertyScopeOutput,
        kAudioObjectPropertyElementMaster
    };


    //Get DefaultAudioOutput volume
    outPropertyData = 0.1;
    ret = AudioHardwareServiceGetPropertyData(defaultOutputDeviceID,
                                        &propertyAddress,
                                        0,
                                        NULL,
                                        &outPropertyDataSize,
                                        &outPropertyData);

    qDebug() << "output volume:" << ret << outPropertyData << outPropertyDataSize;
    return outPropertyData * 100;
}

