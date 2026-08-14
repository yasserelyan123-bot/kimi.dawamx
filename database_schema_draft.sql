-- DawamX production foundation (draft)
-- Do not run until the Supabase project is created and reviewed.

create table public.companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  country_code text not null check (country_code in ('KW','EG','SA','AE','QA','BH','OM')),
  currency_code text not null,
  created_at timestamptz not null default now()
);

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  company_id uuid not null references public.companies(id) on delete cascade,
  employee_id bigint,
  role text not null check (role in ('owner','admin','hr','supervisor','employee')),
  full_name text not null,
  created_at timestamptz not null default now()
);

create table public.employees (
  id bigint generated always as identity primary key,
  company_id uuid not null references public.companies(id) on delete cascade,
  employee_code text not null,
  name_ar text not null,
  name_en text,
  department text,
  position text,
  country_code text not null,
  national_id text,
  passport_no text,
  residency_no text,
  contract_end date,
  residency_end date,
  passport_end date,
  base_salary numeric(14,2) not null default 0,
  created_at timestamptz not null default now(),
  unique(company_id, employee_code)
);

-- Enable RLS before exposing these tables through the client.
alter table public.companies enable row level security;
alter table public.profiles enable row level security;
alter table public.employees enable row level security;
