// Platform-specific component implementations
import React from 'react';
import { isWeb } from '@repo/utils';

// Base props that all platforms should support
interface BaseAlertProps {
  title: string;
  message?: string;
  onConfirm?: () => void;
  onCancel?: () => void;
}

// Web-specific alert component
const WebAlert: React.FC<BaseAlertProps> = ({ title, message, onConfirm, onCancel }) => {
  const showAlert = () => {
    if (onCancel || onConfirm) {
      const result = confirm(message ? `${title}: ${message}` : title);
      if (result && onConfirm) {
        onConfirm();
      } else if (!result && onCancel) {
        onCancel();
      }
    } else {
      alert(message ? `${title}: ${message}` : title);
    }
  };

  React.useEffect(() => {
    showAlert();
  }, []);

  return null; // Web alerts don't render anything
};

// Native alert component
const NativeAlert: React.FC<BaseAlertProps> = ({ title, message, onConfirm, onCancel }) => {
  React.useEffect(() => {
    try {
      const { Alert } = require('react-native');

      if (onConfirm || onCancel) {
        const buttons = [];
        if (onCancel) {
          buttons.push({ text: 'Cancel', style: 'cancel', onPress: onCancel });
        }
        if (onConfirm) {
          buttons.push({ text: 'OK', onPress: onConfirm });
        }
        Alert.alert(title, message, buttons);
      } else {
        Alert.alert(title, message);
      }
    } catch (error) {
      console.warn('Native Alert not available:', error);
      console.warn(title, message);
    }
  }, []);

  return null; // Native alerts don't render anything
};

// Platform-aware alert component
export const PlatformAlert: React.FC<BaseAlertProps> = (props) => {
  if (isWeb) {
    return <WebAlert {...props} />;
  }
  return <NativeAlert {...props} />;
};

// Hook for showing alerts
export const useAlert = () => {
  const showAlert = React.useCallback(
    (title: string, message?: string, onConfirm?: () => void, onCancel?: () => void) => {
      // This is a simplified implementation
      // In a real app, you might want to use a modal system or toast notifications
      if (isWeb) {
        if (onConfirm || onCancel) {
          const result = confirm(message ? `${title}: ${message}` : title);
          if (result && onConfirm) {
            onConfirm();
          } else if (!result && onCancel) {
            onCancel();
          }
        } else {
          alert(message ? `${title}: ${message}` : title);
        }
      } else {
        try {
          const { Alert } = require('react-native');

          if (onConfirm || onCancel) {
            const buttons = [];
            if (onCancel) {
              buttons.push({
                text: 'Cancel',
                style: 'cancel',
                onPress: onCancel,
              });
            }
            if (onConfirm) {
              buttons.push({ text: 'OK', onPress: onConfirm });
            }
            Alert.alert(title, message, buttons);
          } else {
            Alert.alert(title, message);
          }
        } catch (error) {
          console.warn('Native Alert not available:', error);
          console.warn(title, message);
        }
      }
    },
    [],
  );

  return { showAlert };
};
