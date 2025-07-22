// Root page.js - Simple landing page that works without authentication
"use client";

import { useEffect } from "react";
import { useRouter } from "next/navigation";

export default function RootPage() {
  const router = useRouter();

  useEffect(() => {
    // Simple redirect to login page
    // This ensures the app has a working root route
    const timer = setTimeout(() => {
      router.replace("/login");
    }, 100);

    return () => clearTimeout(timer);
  }, [router]);

  // Simple landing page
  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-50 to-indigo-100">
      <div className="text-center max-w-md mx-auto p-8">
        <div className="mb-8">
          <h1 className="text-4xl font-bold text-gray-900 mb-4">
            Intervo.ai
          </h1>
          <p className="text-lg text-gray-600 mb-6">
            Conversational Voice AI Agent
          </p>
          <div className="animate-pulse">
            <div className="h-2 bg-blue-200 rounded-full mb-2"></div>
            <div className="h-2 bg-blue-300 rounded-full w-3/4 mx-auto"></div>
          </div>
        </div>
        <p className="text-sm text-gray-500">
          Redirecting to login...
        </p>
      </div>
    </div>
  );
}
