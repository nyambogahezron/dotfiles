'use client';

import React from 'react';

interface AuthFormProps {
  mode: 'login' | 'register' | 'forgot-password' | 'reset-password';
  resetToken?: string;
}

const AuthForm: React.FC<AuthFormProps> = ({ mode }) => {
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-950 px-4 py-12">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-white">
            {mode === 'login' ? 'Sign In' : 'Sign Up'}
          </h2>
        </div>
        <form className="mt-8 space-y-6">
          <div className="bg-gray-900 p-8 rounded-lg shadow-2xl border border-gray-800">
            <input
              type="email"
              placeholder="Email"
              className="w-full p-3 bg-gray-800 border border-gray-700 text-white rounded"
            />
            <button
              type="submit"
              className="w-full mt-4 py-3 bg-purple-600 text-white rounded hover:bg-purple-700"
            >
              Submit
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};

export default AuthForm;
