/**
 * Basic module
 * what is imported in this file, will be excluded in business module
 * and what is defined in this file, can be consumed in business module
 */

import React, { Component } from 'react';
import {
  NativeEventEmitter,
  NativeModules,
  AppRegistry,
  DeviceEventEmitter,
  View,
  Platform,
  Text,
  TextInput
} from 'react-native';
import { SmartAssets } from 'react-native-smartassets';

/**
 * Notify the RN to update the resource loading path after the bundle is loaded natively
 */
SmartAssets.initSmartAssets();
DeviceEventEmitter.addListener('sm-bundle-changed', (bundlePath) => {
  SmartAssets.setBundlePath(bundlePath);
});

/**
 * Listener load bundle only on iOS
 * to load any assets need based on the bundle loaded
 */
if (Platform.OS !== 'android') {
  const { BundleLoadEventEmitter } = NativeModules;

  const bundleLoadEmitter = new NativeEventEmitter(BundleLoadEventEmitter);

  const subscription = bundleLoadEmitter.addListener(
    'BundleLoad',
    (bundleInfo) => {
      console.log('BundleLoad==' + bundleInfo.path);
      SmartAssets.setBundlePath(bundleInfo.path);
    },
  );
}

require('react-native/Libraries/Core/checkNativeVersion');
