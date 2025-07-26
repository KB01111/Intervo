import { AuthProvider } from "@/context/AuthContext";

export default function VerifyLayout({ children }) {
  return (
    <AuthProvider>
      {children}
    </AuthProvider>
  );
}
