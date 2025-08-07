import React from 'react';

export interface CardProps {
  children: React.ReactNode;
  className?: string;
  style?: any;
  onPress?: () => void;
  testID?: string;
}

export const Card: React.FC<CardProps> = ({ children, className = '', style, onPress, testID }) => {
  const baseClasses = 'bg-white rounded-lg shadow-md overflow-hidden';
  const interactiveClasses = onPress
    ? 'cursor-pointer hover:shadow-lg transition-shadow duration-200'
    : '';
  const classes = `${baseClasses} ${interactiveClasses} ${className}`;

  if (onPress) {
    return (
      <div
        className={classes}
        style={style}
        onClick={onPress}
        data-testid={testID}
        role="button"
        tabIndex={0}
        onKeyDown={(e) => {
          if (e.key === 'Enter' || e.key === ' ') {
            onPress();
          }
        }}
      >
        {children}
      </div>
    );
  }

  return (
    <div className={classes} style={style} data-testid={testID}>
      {children}
    </div>
  );
};
