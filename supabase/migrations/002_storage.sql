-- ============================================================================
-- Sortirin — Storage Buckets & Policies
-- Version: 1.0.0 (M1 Foundation)
-- ============================================================================

-- Create storage buckets
insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values
  ('videos', 'videos', false, 52428800, array['video/mp4', 'video/webm', 'video/quicktime']),
  ('thumbnails', 'thumbnails', true, 1048576, array['image/jpeg', 'image/png', 'image/webp'])
on conflict (id) do nothing;

-- ============================================================================
-- RLS Policies for storage buckets
-- ============================================================================

-- Videos bucket: authenticated users can upload, only owner can read
create policy "Videos — authenticated users can upload"
  on storage.objects for insert
  with check (
    bucket_id = 'videos'
    and auth.role() = 'authenticated'
  );

create policy "Videos — owner can read"
  on storage.objects for select
  using (
    bucket_id = 'videos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Videos — owner can update"
  on storage.objects for update
  using (
    bucket_id = 'videos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Videos — owner can delete"
  on storage.objects for delete
  using (
    bucket_id = 'videos'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

-- Thumbnails bucket: public read, authenticated upload
create policy "Thumbnails — anyone can read"
  on storage.objects for select
  using (bucket_id = 'thumbnails');

create policy "Thumbnails — authenticated users can upload"
  on storage.objects for insert
  with check (
    bucket_id = 'thumbnails'
    and auth.role() = 'authenticated'
  );

create policy "Thumbnails — owner can update"
  on storage.objects for update
  using (
    bucket_id = 'thumbnails'
    and (storage.foldername(name))[1] = auth.uid()::text
  );

create policy "Thumbnails — owner can delete"
  on storage.objects for delete
  using (
    bucket_id = 'thumbnails'
    and (storage.foldername(name))[1] = auth.uid()::text
  );
