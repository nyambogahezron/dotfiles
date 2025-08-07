'use client';

import React, { useEffect, useState } from 'react';
import AuthForm from '@/components/auth/AuthForm';

interface PageProps {
  params: Promise<{
    token: string;
  }>;
}

const ResetPasswordPage: React.FC<PageProps> = ({ params }) => {
  const [token, setToken] = useState<string>('');

  useEffect(() => {
    params.then(({ token }) => setToken(token));
  }, [params]);

  if (!token) {
    return <div>Loading...</div>;
  }

  return <AuthForm mode="reset-password" resetToken={token} />;
};

export default ResetPasswordPage;
