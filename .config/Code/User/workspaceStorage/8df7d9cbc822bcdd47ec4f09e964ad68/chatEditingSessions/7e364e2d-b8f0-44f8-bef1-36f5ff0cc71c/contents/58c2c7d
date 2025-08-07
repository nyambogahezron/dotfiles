# Migration Guide: Magic Links to OTP Authentication

This guide helps developers migrate from the old magic link system to the new OTP-based authentication.

## Frontend Changes Required

### 1. Update Registration Flow

**Before (Magic Link):**
```javascript
// Register user
const response = await fetch('/api/v1/auth/register', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, firstName, lastName, role })
});

// User clicks link in email to verify
// No additional frontend code needed
```

**After (OTP):**
```javascript
// Register user
const response = await fetch('/api/v1/auth/register', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, firstName, lastName, role })
});

const { data } = await response.json();
const { verificationToken } = data;

// Show OTP input form
const otpCode = prompt('Enter the 6-digit code from your email:');

// Verify OTP
const verifyResponse = await fetch('/api/v1/auth/verify-otp', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ 
    otp: otpCode, 
    token: verificationToken 
  })
});
```

### 2. Update Login Flow

**Before (Magic Link):**
```javascript
// Request magic link
const response = await fetch('/api/v1/auth/verify-link', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email, redirectUri: window.location.origin })
});

// User clicks link in email
// Handle redirect with token in URL
```

**After (OTP):**
```javascript
// Request login OTP
const response = await fetch('/api/v1/auth/login', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ email })
});

const { data } = await response.json();
const { loginToken } = data;

// Show OTP input form
const otpCode = prompt('Enter the 6-digit code from your email:');

// Verify OTP
const verifyResponse = await fetch('/api/v1/auth/verify-otp', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ 
    otp: otpCode, 
    token: loginToken 
  })
});

const { data: loginData } = await verifyResponse.json();
// loginData contains user and accessToken
```

## UI Components to Add

### OTP Input Component (React Example)
```jsx
import React, { useState } from 'react';

const OTPInput = ({ length = 6, onComplete }) => {
  const [otp, setOtp] = useState(new Array(length).fill(''));

  const handleChange = (element, index) => {
    if (isNaN(element.value)) return false;

    setOtp([...otp.map((d, idx) => (idx === index ? element.value : d))]);

    // Focus next input
    if (element.nextSibling) {
      element.nextSibling.focus();
    }

    // Check if OTP is complete
    const newOtp = [...otp];
    newOtp[index] = element.value;
    if (newOtp.every(digit => digit !== '')) {
      onComplete(newOtp.join(''));
    }
  };

  return (
    <div className="otp-container">
      {otp.map((data, index) => (
        <input
          className="otp-field"
          type="text"
          name="otp"
          maxLength="1"
          key={index}
          value={data}
          onChange={e => handleChange(e.target, index)}
          onFocus={e => e.target.select()}
        />
      ))}
    </div>
  );
};

// Usage
const VerificationForm = ({ verificationToken }) => {
  const handleOTPComplete = async (otp) => {
    try {
      const response = await fetch('/api/v1/auth/verify-otp', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ otp, token: verificationToken })
      });
      
      if (response.ok) {
        const data = await response.json();
        // Handle successful verification
        console.log('Verified!', data);
      }
    } catch (error) {
      console.error('Verification failed:', error);
    }
  };

  return (
    <div>
      <h3>Enter the 6-digit code sent to your email</h3>
      <OTPInput onComplete={handleOTPComplete} />
    </div>
  );
};
```

### CSS for OTP Input
```css
.otp-container {
  display: flex;
  gap: 10px;
  justify-content: center;
  margin: 20px 0;
}

.otp-field {
  width: 50px;
  height: 50px;
  text-align: center;
  font-size: 24px;
  font-weight: bold;
  border: 2px solid #ddd;
  border-radius: 8px;
  outline: none;
}

.otp-field:focus {
  border-color: #3498db;
  box-shadow: 0 0 5px rgba(52, 152, 219, 0.3);
}
```

## Error Handling

### Common Error Responses
```javascript
// Invalid OTP
{
  "success": false,
  "message": "Invalid OTP",
  "error": "BadRequestError"
}

// Expired token
{
  "success": false,
  "message": "OTP has expired",
  "error": "BadRequestError"
}

// Invalid token type
{
  "success": false,
  "message": "Invalid token type",
  "error": "BadRequestError"
}
```

### Error Handling Example
```javascript
const verifyOTP = async (otp, token) => {
  try {
    const response = await fetch('/api/v1/auth/verify-otp', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ otp, token })
    });

    const data = await response.json();

    if (!response.ok) {
      throw new Error(data.message || 'Verification failed');
    }

    return data;
  } catch (error) {
    if (error.message.includes('expired')) {
      // Show option to resend
      showResendOption();
    } else if (error.message.includes('Invalid OTP')) {
      // Clear input and show error
      clearOTPInput();
      showError('Please check the code and try again');
    }
    throw error;
  }
};
```

## Testing in Development

### View OTP Codes in Console
In development mode, check your server console logs for email content:

```bash
📧 Email sent in development: {
  "to": "user@example.com",
  "subject": "Your Login Code - Task Flow",
  "content": "{\"otp\":\"123456\",\"name\":\"John\"}"
}
```

### Quick Test Commands
```bash
# Test registration
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","firstName":"Test","lastName":"User","role":"user"}'

# Test OTP verification (use OTP from logs)
curl -X POST http://localhost:3000/api/v1/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"otp":"123456","token":"your-jwt-token-from-register-response"}'
```

## Security Considerations

1. **Always validate OTP format** on frontend (6 digits, numbers only)
2. **Implement rate limiting** for OTP verification attempts
3. **Clear OTP input** after failed attempts
4. **Show expiry countdown** to users (15 minutes)
5. **Provide resend option** with cooldown period

## Checklist for Migration

- [ ] Update registration flow to handle OTP verification
- [ ] Update login flow to request and verify OTP
- [ ] Create OTP input UI component
- [ ] Add error handling for expired/invalid OTPs
- [ ] Add resend functionality
- [ ] Update any e2e tests
- [ ] Test email functionality in development
- [ ] Update user documentation
- [ ] Set OTP_SECRET in production environment
