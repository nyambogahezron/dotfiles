'use client';

import React from 'react';
import AuthForm from '../../../../components/auth/AuthForm';

interface PageProps {
  params: Promise<{
    token: string;
  }>;
}

const ResetPasswordPage: React.FC<PageProps> = async ({ params }) => {
  const { token } = await params;
  return <AuthForm mode="reset-password" resetToken={token} />;
};

export default ResetPasswordPage;
