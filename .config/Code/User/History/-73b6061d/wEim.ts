import nodemailer from 'nodemailer';
import NodemailerConfig from '../config/nodeMailer';
import dotenv from 'dotenv';
import { UserForEmail } from '../interfaces';
import logger from '../utils/logger';

dotenv.config();

export class EmailService {
  private static transporter = nodemailer.createTransport(NodemailerConfig());
  private static readonly fromEmail = process.env.EMAIL;
  private static readonly clientUrl = process.env.CLIENT_URL;

  /**
   * Log email content in development environment
   */
  private static logEmailInDevelopment(
    subject: string,
    to: string,
    content: Record<string, unknown>,
    htmlContent?: string
  ) {
    if (process.env.NODE_ENV !== 'production') {
      console.log('\n' + '='.repeat(80));
      console.log('📧 EMAIL SENT IN DEVELOPMENT MODE 📧');
      console.log('='.repeat(80));
      console.log(`📬 To: ${to}`);
      console.log(`📋 Subject: ${subject}`);
      console.log(`⏰ Timestamp: ${new Date().toLocaleString()}`);
      console.log('-'.repeat(80));
      console.log('📄 Content Details:');
      console.log(JSON.stringify(content, null, 2));
      
      if (htmlContent) {
        console.log('-'.repeat(80));
        console.log('🌐 HTML Preview (first 200 chars):');
        console.log(htmlContent.substring(0, 200) + '...');
      }
      
      console.log('='.repeat(80) + '\n');
      
      // Also log to winston logger for file storage
      logger.info('📧 Email sent in development:', {
        to,
        subject,
        timestamp: new Date().toISOString(),
        content,
      });
    }
  }

  static async sendVerificationOTPEmail({
    email,
    name,
    otp,
  }: {
    email: string;
    name: string;
    otp: string;
  }) {
    const mailOptions = {
      from: this.fromEmail,
      to: email,
      subject: 'Verify Your Email Address - Task Flow',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">Welcome to Task Flow!</h2>
          <p>Hi ${name},</p>
          <p>Thank you for signing up. Please verify your email address using the code below:</p>
          
          <div style="text-align: center; margin: 30px 0;">
            <div style="background-color: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 10px; padding: 20px; display: inline-block;">
              <p style="margin: 0 0 10px 0; font-size: 14px; color: #666;">Your verification code:</p>
              <div id="otp-code" style="font-size: 32px; letter-spacing: 8px; font-weight: bold; color: #3498db; margin: 10px 0;">${otp}</div>
              <button onclick="copyOTP()" style="background-color: #28a745; color: white; border: none; padding: 8px 16px; border-radius: 5px; cursor: pointer; font-size: 14px; margin-top: 10px;">
                📋 Copy Code
              </button>
            </div>
          </div>
          
          <p>This code will expire in 15 minutes.</p>
          <p>If you did not create an account, please ignore this email.</p>
          <p>Thank you,<br>The Task Flow Team</p>
          
          <script>
            function copyOTP() {
              const otpText = '${otp}';
              navigator.clipboard.writeText(otpText).then(function() {
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '✓ Copied!';
                button.style.backgroundColor = '#28a745';
                setTimeout(function() {
                  button.innerHTML = originalText;
                  button.style.backgroundColor = '#28a745';
                }, 2000);
              }, function(err) {
                console.error('Could not copy text: ', err);
                alert('Code: ${otp}');
              });
            }
          </script>
        </div>
      `,
    };

    await this.transporter.sendMail(mailOptions);
    this.logEmailInDevelopment(
      mailOptions.subject, 
      email, 
      { otp, name, type: 'email_verification' }, 
      mailOptions.html
    );
  }

  static async sendLoginOTPEmail({
    email,
    name,
    otp,
  }: {
    email: string;
    name: string;
    otp: string;
  }) {
    const mailOptions = {
      from: this.fromEmail,
      to: email,
      subject: 'Your Login Code - Task Flow',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">Login to Task Flow</h2>
          <p>Hi ${name},</p>
          <p>Here's your secure login code:</p>
          
          <div style="text-align: center; margin: 30px 0;">
            <div style="background-color: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 10px; padding: 20px; display: inline-block;">
              <p style="margin: 0 0 10px 0; font-size: 14px; color: #666;">Your login code:</p>
              <div id="otp-code" style="font-size: 32px; letter-spacing: 8px; font-weight: bold; color: #3498db; margin: 10px 0;">${otp}</div>
              <button onclick="copyOTP()" style="background-color: #28a745; color: white; border: none; padding: 8px 16px; border-radius: 5px; cursor: pointer; font-size: 14px; margin-top: 10px;">
                📋 Copy Code
              </button>
            </div>
          </div>
          
          <p>This code will expire in 15 minutes.</p>
          <p>If you did not request this login, you can safely ignore this email.</p>
          <p>Thank you,<br>The Task Flow Team</p>
          
          <script>
            function copyOTP() {
              const otpText = '${otp}';
              navigator.clipboard.writeText(otpText).then(function() {
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '✓ Copied!';
                button.style.backgroundColor = '#28a745';
                setTimeout(function() {
                  button.innerHTML = originalText;
                  button.style.backgroundColor = '#28a745';
                }, 2000);
              }, function(err) {
                console.error('Could not copy text: ', err);
                alert('Code: ${otp}');
              });
            }
          </script>
        </div>
      `,
    };

    await this.transporter.sendMail(mailOptions);
    this.logEmailInDevelopment(
      mailOptions.subject, 
      email, 
      { otp, name, type: 'login' }, 
      mailOptions.html
    );
  }

  static async sendWelcomeEmail(user: UserForEmail) {
    const mailOptions = {
      from: this.fromEmail,
      to: user.email,
      subject: 'Welcome to Task Flow!',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">Welcome to Task Flow!</h2>
          <p>Hi ${user.name},</p>
          <p>Thank you for joining Task Flow. We're excited to have you on board!</p>
          <p>With Task Flow, you can:</p>
          <ul>
            <li>Organize your tasks efficiently</li>
            <li>Collaborate with your team</li>
            <li>Track your progress in real-time</li>
            <li>Set reminders and deadlines</li>
            <li>And much more!</li>
          </ul>
          <p>Get started by exploring the app and adding your first task!</p>
          <p>Thank you,<br>The Task Flow Team</p>
        </div>
      `,
    };

    await this.transporter.sendMail(mailOptions);
    this.logEmailInDevelopment(
      mailOptions.subject, 
      user.email, 
      { userId: user.id, userName: user.name, type: 'welcome' },
      mailOptions.html
    );
  }

  static async sendNewLoginAlert(
    user: UserForEmail,
    ipAddress: string,
    deviceInfo: string
  ) {
    const mailOptions = {
      from: this.fromEmail,
      to: user.email,
      subject: 'New Login Detected - Task Flow',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">New Login Alert</h2>
          <p>Hi ${user.name},</p>
          <p>We detected a new login to your Task Flow account from a new device or location.</p>
          <div style="background-color: #f8f9fa; padding: 15px; border-radius: 5px; margin: 20px 0;">
            <p><strong>IP Address:</strong> ${ipAddress}</p>
            <p><strong>Device Info:</strong> ${deviceInfo}</p>
            <p><strong>Time:</strong> ${new Date().toLocaleString()}</p>
          </div>
          <p>If this was you, you can ignore this email.</p>
          <p>If you don't recognize this activity, please change your password immediately and contact support.</p>
          <p>Thank you,<br>The Task Flow Team</p>
        </div>
      `,
    };

    await this.transporter.sendMail(mailOptions);
    this.logEmailInDevelopment(mailOptions.subject, user.email, {
      ipAddress,
      deviceInfo,
    });
  }

  static async sendPasswordResetEmail(user: UserForEmail, resetCode: string) {
    const resetLink = `${this.clientUrl}/reset-password`;

    const mailOptions = {
      from: this.fromEmail,
      to: user.email,
      subject: 'Reset Your Password - Task Flow',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">Reset Your Password</h2>
          <p>Hi ${user.name},</p>
          <p>You recently requested to reset your password for your Task Flow account.</p>
          
          <div style="text-align: center; margin: 30px 0;">
            <div style="background-color: #f8f9fa; border: 2px dashed #dee2e6; border-radius: 10px; padding: 20px; display: inline-block;">
              <p style="margin: 0 0 10px 0; font-size: 14px; color: #666;">Your reset code:</p>
              <div id="otp-code" style="font-size: 32px; letter-spacing: 8px; font-weight: bold; color: #e74c3c; margin: 10px 0;">${resetCode}</div>
              <button onclick="copyOTP()" style="background-color: #28a745; color: white; border: none; padding: 8px 16px; border-radius: 5px; cursor: pointer; font-size: 14px; margin-top: 10px;">
                📋 Copy Code
              </button>
            </div>
          </div>
          
          <p>Enter this code along with your email and new password on our <a href="${resetLink}">password reset page</a>.</p>
          <p>This code will expire in 15 minutes.</p>
          <p>If you did not request a password reset, please ignore this email or contact support if you have concerns.</p>
          <p>Thank you,<br>The Task Flow Team</p>
          
          <script>
            function copyOTP() {
              const otpText = '${resetCode}';
              navigator.clipboard.writeText(otpText).then(function() {
                const button = event.target;
                const originalText = button.innerHTML;
                button.innerHTML = '✓ Copied!';
                button.style.backgroundColor = '#28a745';
                setTimeout(function() {
                  button.innerHTML = originalText;
                  button.style.backgroundColor = '#28a745';
                }, 2000);
              }, function(err) {
                console.error('Could not copy text: ', err);
                alert('Code: ${resetCode}');
              });
            }
          </script>
        </div>
      `,
    };

    await this.transporter.sendMail(mailOptions);
    this.logEmailInDevelopment(
      mailOptions.subject, 
      user.email, 
      { resetCode, type: 'password_reset', userId: user.id },
      mailOptions.html
    );
  }

  static async sendPasswordChangeNotification(user: UserForEmail) {
    const mailOptions = {
      from: this.fromEmail,
      to: user.email,
      subject: 'Password Changed - Task Flow',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">Password Changed</h2>
          <p>Hi ${user.name},</p>
          <p>The password for your Task Flow account has been changed successfully.</p>
          <p>If you did not make this change, please contact our support team immediately.</p>
          <p>Thank you,<br>The Task Flow Team</p>
        </div>
      `,
    };

    await this.transporter.sendMail(mailOptions);
    this.logEmailInDevelopment(
      mailOptions.subject, 
      user.email, 
      { action: 'password_changed', type: 'notification', userId: user.id },
      mailOptions.html
    );
  }

  static async sendEmailChangeNotification(
    user: UserForEmail,
    oldEmail: string,
    newEmail: string
  ) {
    const mailOptions = {
      from: this.fromEmail,
      to: oldEmail,
      subject: 'Email Address Changed - Task Flow',
      html: `
        <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
          <h2 style="color: #333;">Email Address Changed</h2>
          <p>Hi ${user.name},</p>
          <p>The email address associated with your Task Flow account has been changed from:</p>
          <p><strong>${oldEmail}</strong> to <strong>${newEmail}</strong></p>
          <p>If you did not make this change, please contact our support team immediately.</p>
          <p>Thank you,<br>The Task Flow Team</p>
        </div>
      `,
    };

    await this.transporter.sendMail(mailOptions);
    this.logEmailInDevelopment(
      mailOptions.subject, 
      oldEmail, 
      { oldEmail, newEmail, type: 'email_change', userId: user.id },
      mailOptions.html
    );
  }

  static async sendTestEmail(to: string) {
    const mailOptions = {
      from: this.fromEmail,
      to: to,
      subject: 'Test Email from Task Flow',
      text: 'This is a test email from Task Flow. If you received this, the email service is working correctly.',
    };

    await this.transporter.sendMail(mailOptions);
    this.logEmailInDevelopment(
      mailOptions.subject, 
      to, 
      { type: 'test_email' },
      mailOptions.text
    );
  }
}
