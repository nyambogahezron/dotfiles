/**
 * Custom drag and drop utilities for Kanban board
 */

export interface DragData {
  taskId: string;
  sourceStatus: string;
}

export const createDragHandlers = (
  onTaskMove: (taskId: string, newStatus: string) => void
) => {
  const handleDragStart = (e: React.DragEvent, taskId: string, status: string) => {
    const dragData: DragData = { taskId, sourceStatus: status };
    e.dataTransfer.setData('application/json', JSON.stringify(dragData));
    e.dataTransfer.effectAllowed = 'move';
    
    // Add visual feedback
    const target = e.target as HTMLElement;
    target.style.opacity = '0.5';
  };

  const handleDragEnd = (e: React.DragEvent) => {
    // Remove visual feedback
    const target = e.target as HTMLElement;
    target.style.opacity = '1';
  };

  const handleDragOver = (e: React.DragEvent) => {
    e.preventDefault();
    e.dataTransfer.dropEffect = 'move';
  };

  const handleDragEnter = (e: React.DragEvent) => {
    e.preventDefault();
    // Add visual feedback to drop zone
    const target = e.currentTarget as HTMLElement;
    target.classList.add('drag-over');
  };

  const handleDragLeave = (e: React.DragEvent) => {
    // Remove visual feedback from drop zone
    const target = e.currentTarget as HTMLElement;
    target.classList.remove('drag-over');
  };

  const handleDrop = (e: React.DragEvent, targetStatus: string) => {
    e.preventDefault();
    
    // Remove visual feedback
    const target = e.currentTarget as HTMLElement;
    target.classList.remove('drag-over');

    try {
      const dragDataString = e.dataTransfer.getData('application/json');
      const dragData: DragData = JSON.parse(dragDataString);
      
      // Only move if status is different
      if (dragData.sourceStatus !== targetStatus) {
        onTaskMove(dragData.taskId, targetStatus);
      }
    } catch (error) {
      console.error('Error handling drop:', error);
    }
  };

  return {
    handleDragStart,
    handleDragEnd,
    handleDragOver,
    handleDragEnter,
    handleDragLeave,
    handleDrop,
  };
};
