import { AuthProvider } from "@/context/AuthContext";

export default function SignupLayout({ children }) {
  return (
    <AuthProvider>
      {children}
    </AuthProvider>
  );
}
