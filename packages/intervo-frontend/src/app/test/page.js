// Simple test page to verify routing works
import Link from 'next/link';

export default function TestPage() {
  return (
    <div style={{ padding: '20px', fontFamily: 'Arial, sans-serif' }}>
      <h1>🎉 Intervo Frontend is Working!</h1>
      <p>This is a test page to verify that the Next.js application is running correctly.</p>
      <div style={{ marginTop: '20px', padding: '10px', backgroundColor: '#f0f0f0', borderRadius: '5px' }}>
        <h3>Status:</h3>
        <ul>
          <li>✅ Next.js app is running</li>
          <li>✅ Routing is working</li>
          <li>✅ Domain configuration is correct</li>
        </ul>
      </div>
      <div style={{ marginTop: '20px' }}>
        <Link href="/login" style={{ color: '#0070f3', textDecoration: 'underline' }}>
          Go to Login Page
        </Link>
      </div>
    </div>
  );
}

export const metadata = {
  title: 'Test Page - Intervo',
  description: 'Test page to verify Intervo frontend is working',
};
