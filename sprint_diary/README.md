# Sprint Diary

A personal training diary application for a single athlete, focusing on simplicity and speed.

## Features
- Dashboard with motivational quotes and daily summaries
- Track Training Logs (Gym, Sprints, Recovery, etc.)
- Record Sprint Timings with automatic improvement calculations
- Manage Personal Bests and Goals
- Calendar view for overview of workouts
- Body Measurements tracking
- Journal/Notes
- Offline capability & dark mode

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone <repository_url>
   cd sprint_diary
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Supabase Setup:**
   - Create a new project in Supabase.
   - Run the SQL script found in `supabase/migrations/00_init.sql` in the Supabase SQL editor to create all required tables, Row Level Security (RLS) policies, and triggers.
   - Go to `lib/core/services/supabase_service.dart` and update `supabaseUrl` and `supabaseAnonKey` with your project's keys.

4. **Run the App:**
   ```bash
   flutter run
   ```

## Architecture
This app uses a Feature-First Clean Architecture combined with Riverpod for dependency injection and state management. Navigation is handled by GoRouter.

## Disable Email Verification (Optional)
If you do not want to require email verification for new users:
1. Go to your Supabase Project Dashboard.
2. Navigate to **Authentication** -> **Providers** -> **Email**.
3. Toggle off **Confirm email**.
4. Click **Save**.
This allows users to log in immediately after signing up without clicking a confirmation link.
