-- Seed data for Flutter Social
-- 5 users, 10 posts, 20 comments, 15 likes, 8 follows
--
-- Note: In production, profiles are auto-created by the auth trigger.
-- For seeding, we insert directly into profiles with fixed UUIDs.
-- These UUIDs don't correspond to real auth.users rows, so this seed
-- is meant for local development with Supabase CLI (supabase db reset).

-- =============================================================
-- Users / Profiles
-- =============================================================
insert into public.profiles (id, username, full_name, bio, avatar_url) values
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567801', 'alice_chen',   'Alice Chen',     'Designer & Flutter enthusiast. Making pixels dance since 2019.', 'https://i.pravatar.cc/150?u=alice'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567802', 'bob_markov',   'Bob Markov',     'Backend engineer who accidentally fell in love with Dart.', 'https://i.pravatar.cc/150?u=bob'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567803', 'carol_rivers', 'Carol Rivers',   'Product manager by day, open-source contributor by night.', 'https://i.pravatar.cc/150?u=carol'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567804', 'dave_park',    'Dave Park',      'Mobile dev. Coffee + code = shipping features.', 'https://i.pravatar.cc/150?u=dave'),
  ('a1b2c3d4-e5f6-7890-abcd-ef1234567805', 'elena_sato',   'Elena Sato',     'Tech lead. Building apps that people actually enjoy using.', 'https://i.pravatar.cc/150?u=elena')
on conflict (id) do nothing;

-- =============================================================
-- Posts (10 posts, spread across authors)
-- =============================================================
insert into public.posts (id, author_id, content, image_url, likes_count, created_at) values
  ('11111111-1111-1111-1111-111111111101',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567801',
   'Just shipped a new Flutter feature! The Material 3 dynamic color system is incredible. Every theme change feels buttery smooth.',
   'https://picsum.photos/seed/flutter1/600/400',
   6, now() - interval '2 hours'),

  ('11111111-1111-1111-1111-111111111102',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567802',
   'GoRouter makes Flutter navigation so clean. Declarative routing FTW! No more managing Navigator stacks manually.',
   null,
   4, now() - interval '5 hours'),

  ('11111111-1111-1111-1111-111111111103',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567803',
   'Riverpod 2.x with code generation is the best state management solution I have used. The autoDispose behavior alone saves so many bugs.',
   null,
   5, now() - interval '8 hours'),

  ('11111111-1111-1111-1111-111111111104',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567801',
   'Exploring the new Impeller rendering engine. Performance gains are real -- 60fps on complex animations that used to jank.',
   'https://picsum.photos/seed/impeller/600/400',
   3, now() - interval '1 day'),

  ('11111111-1111-1111-1111-111111111105',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567804',
   'Hot reload is the feature I miss most when switching to any other framework. Nothing else comes close to that feedback loop.',
   null,
   2, now() - interval '1 day 4 hours'),

  ('11111111-1111-1111-1111-111111111106',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567805',
   'Just migrated our entire app from Provider to Riverpod. Took a weekend but the code is so much cleaner now. Worth every line changed.',
   null,
   4, now() - interval '2 days'),

  ('11111111-1111-1111-1111-111111111107',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567802',
   'Supabase + Flutter is an absolute powerhouse combo. Auth, DB, and realtime -- all working in 20 minutes flat.',
   'https://picsum.photos/seed/supabase/600/400',
   5, now() - interval '2 days 6 hours'),

  ('11111111-1111-1111-1111-111111111108',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567803',
   'Shipped our first production Flutter web app today. The fact that we went from mobile to web with minimal changes still blows my mind.',
   null,
   3, now() - interval '3 days'),

  ('11111111-1111-1111-1111-111111111109',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567804',
   'Tip: use const constructors everywhere you can in Flutter. The framework skips rebuilding const widgets entirely. Free performance.',
   null,
   2, now() - interval '4 days'),

  ('11111111-1111-1111-1111-111111111110',
   'a1b2c3d4-e5f6-7890-abcd-ef1234567805',
   'The Flutter DevTools memory profiler helped me track down a leak that was causing OOM crashes on older devices. Essential tooling.',
   'https://picsum.photos/seed/devtools/600/400',
   1, now() - interval '5 days')
on conflict (id) do nothing;

-- =============================================================
-- Comments (20 comments across posts)
-- =============================================================
insert into public.comments (id, post_id, author_id, content, created_at) values
  -- Post 1 comments (3)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111101', 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', 'Material 3 is a game changer! The color harmonies are beautiful.', now() - interval '1 hour 50 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111101', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', 'Agreed! Dynamic color makes theming so much easier.', now() - interval '1 hour 30 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111101', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', 'We adopted it last month and our designers love the consistency.', now() - interval '1 hour'),

  -- Post 2 comments (2)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111102', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', 'GoRouter + ShellRoute for bottom nav is so elegant.', now() - interval '4 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111102', 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', 'Have you tried the redirect guards? Super handy for auth flows.', now() - interval '3 hours 30 minutes'),

  -- Post 3 comments (3)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111103', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', 'The code generation makes providers feel like magic.', now() - interval '7 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111103', 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', 'autoDispose + keepAlive is the perfect combo for caching.', now() - interval '6 hours 30 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111103', 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', 'Switched from BLoC to Riverpod and never looked back.', now() - interval '6 hours'),

  -- Post 4 comments (2)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111104', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', 'Impeller on iOS is rock solid. Android is catching up fast.', now() - interval '20 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111104', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', 'The shader compilation jank is basically gone. Huge win for UX.', now() - interval '18 hours'),

  -- Post 5 comments (2)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111105', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', 'Hot reload is why I chose Flutter in the first place!', now() - interval '1 day 2 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111105', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', 'SwiftUI preview is good but hot reload is still faster.', now() - interval '1 day 1 hour'),

  -- Post 6 comments (2)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111106', 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', 'How was the migration path? Any gotchas with existing tests?', now() - interval '1 day 20 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111106', 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', 'We did the same migration. The hardest part was updating test overrides.', now() - interval '1 day 18 hours'),

  -- Post 7 comments (2)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111107', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', 'Supabase auth with magic links is so smooth for onboarding.', now() - interval '2 days 4 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111107', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', 'The realtime subscriptions are perfect for chat features.', now() - interval '2 days 2 hours'),

  -- Post 8 comments (1)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111108', 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', 'Flutter web performance has improved so much in the last year.', now() - interval '2 days 18 hours'),

  -- Post 9 comments (2)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111109', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', 'Great tip! Also: prefer final fields in your data classes.', now() - interval '3 days 20 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111109', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', 'The analyzer enforces this if you enable prefer_const_constructors.', now() - interval '3 days 18 hours'),

  -- Post 10 comments (1)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111110', 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', 'DevTools is underrated. The network tab saved me hours of debugging.', now() - interval '4 days 18 hours')
on conflict do nothing;

-- =============================================================
-- Likes (15 likes, matching the likes_count values set above)
-- =============================================================
insert into public.likes (id, post_id, user_id, created_at) values
  -- Post 1: 6 likes
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111101', 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', now() - interval '1 hour 55 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111101', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', now() - interval '1 hour 40 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111101', 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', now() - interval '1 hour 30 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111101', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', now() - interval '1 hour 20 minutes'),
  -- Post 2: 4 likes
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111102', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', now() - interval '4 hours 30 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111102', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', now() - interval '4 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111102', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', now() - interval '3 hours 45 minutes'),
  -- Post 3: 5 likes
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111103', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', now() - interval '7 hours 30 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111103', 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', now() - interval '7 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111103', 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', now() - interval '6 hours 30 minutes'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111103', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', now() - interval '6 hours'),
  -- Post 7: 5 likes (Supabase post -- popular)
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111107', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', now() - interval '2 days 5 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111107', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', now() - interval '2 days 4 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111107', 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', now() - interval '2 days 3 hours'),
  (gen_random_uuid(), '11111111-1111-1111-1111-111111111107', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', now() - interval '2 days 2 hours')
on conflict do nothing;

-- =============================================================
-- Follows (8 follow relationships)
-- =============================================================
insert into public.follows (id, follower_id, following_id, created_at) values
  (gen_random_uuid(), 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', now() - interval '30 days'),
  (gen_random_uuid(), 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', now() - interval '28 days'),
  (gen_random_uuid(), 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', now() - interval '29 days'),
  (gen_random_uuid(), 'a1b2c3d4-e5f6-7890-abcd-ef1234567802', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', now() - interval '20 days'),
  (gen_random_uuid(), 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', now() - interval '25 days'),
  (gen_random_uuid(), 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', 'a1b2c3d4-e5f6-7890-abcd-ef1234567801', now() - interval '22 days'),
  (gen_random_uuid(), 'a1b2c3d4-e5f6-7890-abcd-ef1234567804', 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', now() - interval '15 days'),
  (gen_random_uuid(), 'a1b2c3d4-e5f6-7890-abcd-ef1234567805', 'a1b2c3d4-e5f6-7890-abcd-ef1234567803', now() - interval '18 days')
on conflict do nothing;
