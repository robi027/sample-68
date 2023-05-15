import * as React from 'react';
import {AppRegistry, View, Text, Button, NativeModules} from 'react-native';

const App = () => (
  <View style={{flex: 1, alignItems: 'center', justifyContent: 'center', backgroundColor: 'white'}}>
    <Text>Profile</Text>
    <Button
      title="Go Back"
      onPress={() => NativeModules.NavigationBridge.pop()}
    />
  </View>
);

AppRegistry.registerComponent('profile', () => App);
