'use client';

import React, { useEffect, useState } from 'react';
import { DragDropContext, DropResult } from 'react-beautiful-dnd';

interface DragDropWrapperProps {
  onDragEnd: (result: DropResult) => void;
  children: React.ReactNode;
}

export default function DragDropWrapper({ onDragEnd, children }: DragDropWrapperProps) {
  const [isClient, setIsClient] = useState(false);

  useEffect(() => {
    setIsClient(true);
  }, []);

  if (!isClient) {
    return <div>{children}</div>;
  }

  return (
    <DragDropContext onDragEnd={onDragEnd}>
      {children}
    </DragDropContext>
  );
}
