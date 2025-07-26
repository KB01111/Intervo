import { Toaster } from "@/components/ui/toaster";
import { AuthProvider } from "@/context/AuthContext";
import { PlaygroundProvider } from "@/context/AgentContext";
import { SiteHeader } from "@/components/navbar/site-header";
import { WorkspaceProvider } from "@/context/WorkspaceContext";
import { SourceProvider } from "@/context/SourceContext";
import ProtectedRoute from "@/components/ProtectedRoute";

export default async function AppLayout({ children, params }) {
  return (
    <AuthProvider>
      <ProtectedRoute>
        <WorkspaceProvider>
          <SourceProvider>
            <PlaygroundProvider>
              <div className="flex flex-col">
                {!(await params?.slug) && <SiteHeader />}
                {children}
              </div>
              <Toaster />
            </PlaygroundProvider>
          </SourceProvider>
        </WorkspaceProvider>
      </ProtectedRoute>
    </AuthProvider>
  );
}
