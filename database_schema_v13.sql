-- DawamX V13 production-oriented schema draft
-- Multi-company / GCC + Egypt foundation
create extension if not exists pgcrypto;

create table if not exists companies (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  country_code text not null default 'KW',
  currency_code text not null default 'KWD',
  created_at timestamptz not null default now()
);

create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  company_id uuid not null references companies(id) on delete cascade,
  role text not null check (role in ('owner','admin','hr','supervisor','employee')),
  employee_id uuid,
  created_at timestamptz not null default now()
);

create table if not exists employees (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  employee_no text not null,
  name_ar text not null,
  name_en text,
  email text,
  phone text,
  department text,
  position text,
  nationality text,
  country_code text not null default 'KW',
  civil_id text,
  national_id text,
  residency_no text,
  residency_expiry date,
  passport_no text,
  passport_expiry date,
  contract_start date,
  contract_end date,
  basic_salary numeric(12,2) not null default 0,
  housing_allowance numeric(12,2) not null default 0,
  transport_allowance numeric(12,2) not null default 0,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  unique(company_id, employee_no)
);

create table if not exists leave_requests (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  employee_id uuid not null references employees(id) on delete cascade,
  leave_type text not null,
  start_date date not null,
  end_date date not null,
  days numeric(8,2) not null,
  reason text,
  status text not null default 'pending',
  decision_note text,
  decided_by uuid references auth.users(id),
  decided_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists advance_requests (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  employee_id uuid not null references employees(id) on delete cascade,
  amount numeric(12,2) not null,
  installments integer not null default 1,
  reason text,
  status text not null default 'pending',
  decision_note text,
  decided_by uuid references auth.users(id),
  decided_at timestamptz,
  created_at timestamptz not null default now()
);

create table if not exists attendance (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  employee_id uuid not null references employees(id) on delete cascade,
  work_date date not null,
  check_in timestamptz,
  check_out timestamptz,
  status text not null default 'present',
  notes text,
  unique(employee_id, work_date)
);

create table if not exists audit_logs (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references companies(id) on delete cascade,
  actor_id uuid references auth.users(id),
  action text not null,
  entity_type text,
  entity_id uuid,
  details jsonb,
  created_at timestamptz not null default now()
);

-- Every tenant-owned table should use RLS before production exposure.
alter table companies enable row level security;
alter table profiles enable row level security;
alter table employees enable row level security;
alter table leave_requests enable row level security;
alter table advance_requests enable row level security;
alter table attendance enable row level security;
alter table audit_logs enable row level security;

create index if not exists employees_company_employee_no_idx on employees(company_id, employee_no);
create index if not exists employees_company_name_idx on employees(company_id, name_ar);
create index if not exists attendance_employee_date_idx on attendance(employee_id, work_date desc);
create index if not exists leave_company_status_idx on leave_requests(company_id, status);
create index if not exists advance_company_status_idx on advance_requests(company_id, status);
