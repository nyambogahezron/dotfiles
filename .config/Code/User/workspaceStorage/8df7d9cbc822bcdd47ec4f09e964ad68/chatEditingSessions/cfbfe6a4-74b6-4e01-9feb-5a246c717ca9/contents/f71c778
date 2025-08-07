# Discussion and Chat Implementation Guide

## Overview
This implementation provides real-time discussion and chat functionality for your task management application with the following features:

- **Real-time messaging** via Socket.IO
- **Threaded discussions** with nested replies and comments
- **Project-based chat** with participant management
- **Task-specific discussions** for focused conversations
- **Message editing and deletion** with proper authorization
- **Typing indicators** and user presence
- **Comprehensive error handling** with proper HTTP status codes

## API Endpoints

### Chat Endpoints
```
POST   /api/v1/chat/messages                    - Send a message
GET    /api/v1/chat/projects/:projectId/messages - Get project messages (paginated)
GET    /api/v1/chat/projects/:projectId/messages/recent - Get recent messages
GET    /api/v1/chat/messages/:messageId         - Get specific message
PUT    /api/v1/chat/messages/:messageId         - Update message (sender only)
DELETE /api/v1/chat/messages/:messageId         - Delete message (sender only)
GET    /api/v1/chat/projects/:projectId/participants - Get chat participants
```

### Discussion Endpoints
```
POST   /api/v1/discussions                      - Create discussion
GET    /api/v1/discussions/project/:projectId   - Get project discussions
GET    /api/v1/discussions/task/:taskId         - Get task discussions
GET    /api/v1/discussions/:discussionId        - Get discussion with replies/comments
PUT    /api/v1/discussions/:discussionId        - Update discussion (author only)
DELETE /api/v1/discussions/:discussionId        - Delete discussion (author only)
POST   /api/v1/discussions/:discussionId/reply  - Reply to discussion
GET    /api/v1/discussions/:discussionId/comments - Get discussion comments
POST   /api/v1/discussions/comments             - Add comment to discussion
PUT    /api/v1/discussions/comments/:commentId  - Update comment (author only)
DELETE /api/v1/discussions/comments/:commentId  - Delete comment (author only)
POST   /api/v1/discussions/comments/:commentId/reply - Reply to comment
```

## Socket Events

### Client to Server Events

#### Chat Events
- `join_project`: Join project chat room
- `leave_project`: Leave project chat room  
- `send_message`: Send a chat message
- `typing_start`: Start typing indicator
- `typing_stop`: Stop typing indicator
- `message_updated`: Broadcast message update
- `message_deleted`: Broadcast message deletion

#### Discussion Events
- `join_discussion`: Join discussion room
- `leave_discussion`: Leave discussion room
- `discussion_created`: Broadcast new discussion
- `discussion_updated`: Broadcast discussion update
- `comment_added`: Broadcast new comment
- `comment_updated`: Broadcast comment update
- `discussion_typing_start`: Start typing in discussion
- `discussion_typing_stop`: Stop typing in discussion

### Server to Client Events

#### Chat Events
- `joined_project`: Confirmation of joining project
- `left_project`: Confirmation of leaving project
- `new_message`: New message received
- `user_typing`: User started typing
- `user_stopped_typing`: User stopped typing
- `message_updated`: Message was updated
- `message_deleted`: Message was deleted

#### Discussion Events
- `new_discussion`: New discussion created
- `discussion_updated`: Discussion was updated
- `new_comment`: New comment added
- `comment_updated`: Comment was updated
- `user_joined_discussion`: User joined discussion
- `user_left_discussion`: User left discussion
- `user_typing_in_discussion`: User typing in discussion
- `user_stopped_typing_in_discussion`: User stopped typing

## Usage Examples

### Frontend Integration (React/TypeScript)

#### 1. Socket Connection Setup
```typescript
import { io, Socket } from 'socket.io-client';

const socket: Socket = io('http://localhost:3000', {
  auth: {
    token: localStorage.getItem('accessToken')
  }
});

// Join project room
socket.emit('join_project', projectId);

// Listen for new messages
socket.on('new_message', (message) => {
  setMessages(prev => [...prev, message]);
});
```

#### 2. Sending Messages
```typescript
const sendMessage = async (content: string, projectId: string) => {
  try {
    const response = await fetch('/api/v1/chat/messages', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'include',
      body: JSON.stringify({
        content,
        projectId,
        messageType: 'text'
      })
    });
    
    const data = await response.json();
    if (data.success) {
      // Message sent via API, real-time update via socket
      console.log('Message sent:', data.data);
    }
  } catch (error) {
    console.error('Error sending message:', error);
  }
};
```

#### 3. Creating Discussions
```typescript
const createDiscussion = async (title: string, content: string, projectId: string) => {
  try {
    const response = await fetch('/api/v1/discussions', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      credentials: 'include',
      body: JSON.stringify({
        title,
        content,
        projectId
      })
    });
    
    const data = await response.json();
    if (data.success) {
      // Broadcast to other users
      socket.emit('discussion_created', {
        discussionId: data.data.id,
        projectId,
        discussion: data.data
      });
    }
  } catch (error) {
    console.error('Error creating discussion:', error);
  }
};
```

#### 4. Typing Indicators
```typescript
let typingTimer: NodeJS.Timeout;

const handleTyping = (projectId: string) => {
  socket.emit('typing_start', { projectId });
  
  clearTimeout(typingTimer);
  typingTimer = setTimeout(() => {
    socket.emit('typing_stop', { projectId });
  }, 2000);
};

// Listen for typing indicators
socket.on('user_typing', ({ userId, userName }) => {
  setTypingUsers(prev => [...prev, { userId, userName }]);
});

socket.on('user_stopped_typing', ({ userId }) => {
  setTypingUsers(prev => prev.filter(user => user.userId !== userId));
});
```

## Database Schema

The implementation uses the existing schema with these key tables:

### Messages Table
- `id`: UUID primary key
- `content`: Message content
- `senderId`: Reference to users table
- `projectId`: Reference to projects table
- `messageType`: 'text', 'file', 'image'
- `metadata`: JSON for additional data
- `createdAt`, `updatedAt`: Timestamps

### Discussions Table
- `id`: UUID primary key
- `title`: Discussion title
- `content`: Discussion content
- `authorId`: Reference to users table
- `projectId`: Optional reference to projects table
- `taskId`: Optional reference to tasks table
- `parentDiscussionId`: Self-reference for nested discussions
- `createdAt`, `updatedAt`: Timestamps

### Comments Table
- `id`: UUID primary key
- `content`: Comment content
- `authorId`: Reference to users table
- `discussionId`: Reference to discussions table
- `parentCommentId`: Self-reference for nested comments
- `createdAt`, `updatedAt`: Timestamps

## Security Features

1. **Authentication**: All endpoints require valid JWT tokens
2. **Authorization**: Users can only access projects they're members of
3. **Ownership**: Only authors can edit/delete their content
4. **Input Validation**: Comprehensive validation using Zod schemas
5. **Rate Limiting**: Applied at the application level
6. **Error Handling**: Proper error responses without sensitive data leaks

## Performance Considerations

1. **Pagination**: All list endpoints support pagination
2. **Indexing**: Database indexes on frequently queried fields
3. **Real-time Optimization**: Socket rooms for efficient broadcasting
4. **Message Limits**: Content length limits to prevent abuse
5. **Connection Management**: Proper socket connection lifecycle

## Testing

### Example API Tests
```javascript
// Test message sending
describe('POST /api/v1/chat/messages', () => {
  it('should send a message successfully', async () => {
    const response = await request(app)
      .post('/api/v1/chat/messages')
      .set('Cookie', authCookie)
      .send({
        content: 'Test message',
        projectId: testProjectId
      });
    
    expect(response.status).toBe(201);
    expect(response.body.success).toBe(true);
    expect(response.body.data.content).toBe('Test message');
  });
});
```

### Socket Event Testing
```javascript
// Test real-time messaging
describe('Socket Events', () => {
  it('should broadcast new messages', (done) => {
    clientSocket.emit('send_message', {
      content: 'Test message',
      projectId: testProjectId
    });
    
    clientSocket.on('new_message', (message) => {
      expect(message.content).toBe('Test message');
      done();
    });
  });
});
```

## Error Handling

The implementation uses custom error classes:
- `NotFoundError` (404): Resource not found
- `ForbiddenError` (403): Access denied
- `BadRequestError` (400): Invalid input
- `InternalServerError` (500): Server errors

All errors are properly logged and return consistent JSON responses.

## Next Steps

1. **File Upload**: Extend message types to support file attachments
2. **Message Reactions**: Add emoji reactions to messages
3. **Message Search**: Implement full-text search for messages and discussions
4. **Notifications**: Integrate with notification system for mentions
5. **Message History**: Archive old messages for performance
6. **Moderation**: Add content moderation features
7. **Analytics**: Track engagement metrics

## Environment Variables

Add these to your `.env` file:
```
SOCKET_CORS_ORIGIN=http://localhost:3000,http://localhost:3001
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```
