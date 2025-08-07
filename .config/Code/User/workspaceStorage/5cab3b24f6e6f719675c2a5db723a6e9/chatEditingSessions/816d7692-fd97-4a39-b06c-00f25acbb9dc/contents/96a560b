'use client';

import React from 'react';
import AuthForm from '../../../../components/auth/AuthForm';

interface PageProps {
  params: {
    token: string;
  };
}

const ResetPasswordPage: React.FC<PageProps> = ({ params }) => {
  return <AuthForm mode="reset-password" resetToken={params.token} />;
};

export default ResetPasswordPage;
