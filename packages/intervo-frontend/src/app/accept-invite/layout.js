import { AuthProvider } from "@/context/AuthContext";
import { WorkspaceProvider } from "@/context/WorkspaceContext";
import { Toaster } from "@/components/ui/toaster";

export default function AcceptInviteLayout({ children }) {
  return (
    <AuthProvider>
      <WorkspaceProvider>
        {children}
        <Toaster />
      </WorkspaceProvider>
    </AuthProvider>
  );
}
