# Supabase Authentication Setup for Intervo

This guide explains how to configure Supabase authentication for your Intervo deployment.

## 🔧 Supabase Project Setup

### 1. Get Your Supabase Credentials

From your Supabase project dashboard (https://app.supabase.com):

1. Go to **Settings** → **API**
2. Copy the following values:
   - **Project URL**: `https://your-project-id.supabase.co`
   - **Anon (public) key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`
   - **Service role (secret) key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

3. Go to **Settings** → **Auth** → **JWT Settings**
   - Copy the **JWT Secret**: Used for token verification

### 2. Configure Authentication Providers

In Supabase Dashboard → **Authentication** → **Providers**:

#### Enable Email Authentication
- Toggle **Enable email confirmations** if you want email verification
- Set **Site URL** to: `https://app.atlas-agent.net`
- Add **Redirect URLs**:
  - `https://app.atlas-agent.net/auth/callback`
  - `https://api.atlas-agent.net/auth/callback`

#### Optional: Enable OAuth Providers
- **Google**: Add your Google OAuth credentials
- **GitHub**: Add your GitHub OAuth credentials
- **Other providers** as needed

### 3. Database Schema Setup

Run these SQL commands in Supabase SQL Editor:

```sql
-- Create profiles table for user data
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users(id) PRIMARY KEY,
  email TEXT,
  full_name TEXT,
  avatar_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Enable RLS (Row Level Security)
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create policy for users to read their own profile
CREATE POLICY "Users can view own profile" ON profiles
  FOR SELECT USING (auth.uid() = id);

-- Create policy for users to update their own profile
CREATE POLICY "Users can update own profile" ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- Create policy for users to insert their own profile
CREATE POLICY "Users can insert own profile" ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

-- Function to handle new user registration
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.profiles (id, email, full_name)
  VALUES (NEW.id, NEW.email, NEW.raw_user_meta_data->>'full_name');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Trigger to automatically create profile on signup
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
```

## 🔑 Environment Variables Configuration

### In Dokploy UI, set these environment variables:

```env
# Supabase Configuration
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.your-actual-anon-key
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.your-actual-service-role-key
SUPABASE_JWT_SECRET=your-supabase-jwt-secret-from-settings

# NextAuth Configuration
NEXTAUTH_URL=https://api.atlas-agent.net
NEXTAUTH_SECRET=your-nextauth-secret-minimum-32-characters-here

# Application URLs
BASE_URL=https://api.atlas-agent.net
FRONTEND_URL=https://app.atlas-agent.net
```

### Frontend Environment Variables

Also configure in your frontend environment:

```env
NEXT_PUBLIC_SUPABASE_URL=https://your-project-id.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.your-actual-anon-key
NEXTAUTH_URL=https://app.atlas-agent.net
```

## 🔐 Security Best Practices

1. **Never expose service role key** in frontend code
2. **Use anon key only** for client-side operations
3. **Enable RLS** on all tables containing user data
4. **Set up proper CORS** in Supabase settings
5. **Use HTTPS only** in production

## 🧪 Testing Authentication

After deployment, test these endpoints:

1. **Health Check**: `https://api.atlas-agent.net/health`
2. **Auth Status**: `https://api.atlas-agent.net/auth/session`
3. **Frontend**: `https://app.atlas-agent.net`

## 🚨 Troubleshooting

### Common Issues:

1. **CORS Errors**: Check Supabase CORS settings
2. **JWT Verification Failed**: Verify JWT_SECRET matches Supabase
3. **Redirect Issues**: Check redirect URLs in Supabase auth settings
4. **RLS Errors**: Ensure proper policies are set up

### Debug Steps:

1. Check Supabase logs in dashboard
2. Verify environment variables are set correctly
3. Test API endpoints individually
4. Check browser network tab for auth requests

## 📚 Additional Resources

- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [NextAuth.js with Supabase](https://next-auth.js.org/providers/supabase)
- [Row Level Security Guide](https://supabase.com/docs/guides/auth/row-level-security)
