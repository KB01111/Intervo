import "@/app/globals.css";

export const metadata = {
  title: {
    default: "Intervo.ai | Conversational Voice AI Agent",
    template: "Intervo.ai - %s",
  },
  description:
    "Intervo offers a powerful, open-source voice assistant solution that reduces the complexity of creating multimodal, AI-driven applications, giving you the freedom to focus on innovation.",
  icons: {
    icon: "https://res.cloudinary.com/dmuecdqxy/q_auto/v1736911486/CA3xT9cd/interv-iconpng_1736911485_36618.png",
  },
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body>
        {children}
      </body>
    </html>
  );
}
