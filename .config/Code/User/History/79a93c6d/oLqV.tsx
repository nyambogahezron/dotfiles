// import Hero from '@/components/Hero';
// import Features from '@/components/Features';
// import HowItWorks from '@/components/HowItWorks';
// import Testimonials from '@/components/Testimonials';
// import CTA from '@/components/CTA';
// import Footer from '@/components/Footer';
// import { Navbar } from '@/components/Navbar';
// import Newsletter from '@/components/Newsletter';

export const metadata = {
  title: 'Home',
  description: 'Welcome to Task Flow, your ultimate task management solution.',
};

export default function Home() {
  return (
    <div className="min-h-screen">
      <Navbar />
      <Hero />
      <Features />
      <HowItWorks />
      <Testimonials />
      <CTA />
      <Newsletter />
      <Footer />
    </div>
  );
}
