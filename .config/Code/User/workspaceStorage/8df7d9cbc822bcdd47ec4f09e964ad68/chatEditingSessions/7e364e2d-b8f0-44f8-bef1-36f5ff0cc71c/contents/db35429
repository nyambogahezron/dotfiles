# Enhanced Email Development Logging

This document explains how to use the enhanced email logging features for development and testing.

## Features

✅ **Enhanced Console Logging** - Beautiful formatted output in development  
✅ **File Logging** - All emails logged to winston log files  
✅ **OTP Code Display** - Clear visibility of OTP codes for testing  
✅ **HTML Preview** - Preview of email HTML content  
✅ **Test Endpoints** - API endpoints for testing email functionality  

## Console Output Example

When an email is sent in development, you'll see output like this:

```
================================================================================
📧 EMAIL SENT IN DEVELOPMENT MODE 📧
================================================================================
📬 To: user@example.com
📋 Subject: Your Login Code - Task Flow
⏰ Timestamp: 8/4/2025, 8:47:22 PM
--------------------------------------------------------------------------------
📄 Content Details:
{
  "otp": "123456",
  "name": "John",
  "type": "login"
}
--------------------------------------------------------------------------------
🌐 HTML Preview (first 200 chars):

        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">Login to Task Flow</h2>
          <p>Hi John,</p>...
================================================================================
```

## Test Endpoints (Development Only)

### Basic Test Email
```bash
curl -X POST http://localhost:3000/api/v1/dev/test-email \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","type":"basic"}'
```

### Test OTP Email  
```bash
curl -X POST http://localhost:3000/api/v1/dev/test-email \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","type":"otp"}'
```

### Test Verification OTP
```bash
curl -X POST http://localhost:3000/api/v1/dev/test-verification-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User"}'
```

### Test Login OTP
```bash
curl -X POST http://localhost:3000/api/v1/dev/test-login-otp \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","name":"Test User"}'
```

## Using Development Endpoints

Add the development routes to your main app (in development only):

```typescript
// In your main.ts or app.ts
if (process.env.NODE_ENV !== 'production') {
  const devRoutes = require('./routes/dev.routes').default;
  app.use('/api/v1/dev', devRoutes);
}
```

## Log Files

All emails are also logged to files:
- `logs/combined.log` - All log entries including email logs
- `logs/error.log` - Error logs only

### Sample Log File Entry
```json
{
  "level": "info",
  "message": "📧 Email sent in development:",
  "service": "task-flow-server",
  "timestamp": "2025-08-04T20:47:22.123Z",
  "to": "user@example.com",
  "subject": "Your Login Code - Task Flow",
  "content": {
    "otp": "123456",
    "name": "John",
    "type": "login"
  }
}
```

## Environment Configuration

The logging automatically activates when:
```bash
NODE_ENV=development  # or any value except 'production'
```

To disable logging:
```bash
NODE_ENV=production
```

## Email Types Logged

| Email Type | Content Logged | HTML Preview |
|------------|----------------|--------------|
| **Verification OTP** | `otp`, `name`, `type` | ✅ |
| **Login OTP** | `otp`, `name`, `type` | ✅ |
| **Welcome** | `userId`, `userName`, `type` | ✅ |
| **Password Reset** | `resetCode`, `userId`, `type` | ✅ |
| **Login Alert** | `ipAddress`, `deviceInfo`, `userId`, `type` | ✅ |
| **Password Changed** | `action`, `userId`, `type` | ✅ |
| **Email Changed** | `oldEmail`, `newEmail`, `userId`, `type` | ✅ |
| **Test Email** | `type` | ✅ |

## Testing Real Authentication Flow

1. **Register a new user:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "firstName": "Test",
    "lastName": "User",
    "role": "user"
  }'
```

2. **Check console logs** for the OTP code (e.g., `123456`)

3. **Verify email with OTP:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "otp": "123456",
    "token": "jwt-token-from-register-response"
  }'
```

4. **Request login OTP:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email": "test@example.com"}'
```

5. **Check console logs** for the login OTP code

6. **Complete login:**
```bash
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{
    "otp": "654321",
    "token": "jwt-login-token-from-login-response"
  }'
```

## Debugging Tips

### No Emails Appearing in Logs?
- Check `NODE_ENV` environment variable
- Ensure email service is properly configured
- Check that `EMAIL` environment variable is set

### Want to See More Details?
- Check `logs/combined.log` file for complete JSON logs
- Increase `LOG_LEVEL=debug` in your environment

### Testing Copy Button Functionality
- The copy button works in real browsers but not in email previews
- Test with actual email clients or use the HTML preview in browser

## Security Note

⚠️ **Important**: Email logging is automatically disabled in production (`NODE_ENV=production`) to prevent sensitive information leakage. Never enable email logging in production environments.
