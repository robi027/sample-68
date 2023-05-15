/**
 * @format
 */

import * as React from 'react';
import {AppRegistry, View, Button, NativeModules} from 'react-native';
import {name as appName} from './app.json';

const App = () => (
  <View style={{flex: 1, alignItems: 'center', justifyContent: 'center'}}>
    <Button
      title="Profile"
      onPress={() => NativeModules.NavigationBridge.push({to: 'profile'})}
    />
  </View>
);

AppRegistry.registerComponent(appName, () => App);
