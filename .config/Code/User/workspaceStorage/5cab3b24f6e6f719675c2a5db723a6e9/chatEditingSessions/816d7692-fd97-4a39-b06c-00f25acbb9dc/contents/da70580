import type { Metadata } from 'next';
import './globals.css';
import { QueryWrapper } from '@repo/services';
import Navbar from '../components/layout/Navbar';
import Footer from '../components/layout/Footer';

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
        <QueryWrapper>
          <div className="flex flex-col min-h-screen">
            <Navbar />
            <main className="flex-grow">{children}</main>
            <Footer />
          </div>
        </QueryWrapper>
      </body>
    </html>
  );
}
