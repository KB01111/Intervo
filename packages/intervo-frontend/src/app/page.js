// Root page - simple redirect to login
import { redirect } from 'next/navigation';

export default function RootPage() {
  // Server-side redirect to login page
  redirect('/login');
}

// Add metadata for better SEO
export const metadata = {
  title: 'Intervo - AI Voice Agents',
  description: 'Intervo AI Voice Agents Platform',
};
