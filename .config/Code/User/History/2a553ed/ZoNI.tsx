import type { Metadata } from 'next';
import './globals.css';
import { QueryWrapper } from '@repo/services';

export const metadata: Metadata = {
  title: 'Movie Diary',
  description: 'Track your favorite movies and TV shows',
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en">
      <body className="bg-black text-white min-h-screen">
        <QueryWrapper>{children}</QueryWrapper>
      </body>
    </html>
  );
}
