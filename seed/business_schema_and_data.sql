--
-- PostgreSQL database dump
--

\restrict g1iUYyLXRMmeYi2zYFVOX0lMXMOXiWS06x5IevTlgqkUxTHDEznjnWGNm6fCCbe

-- Dumped from database version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.15 (Ubuntu 16.15-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: business; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA business;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.activity (
    id bigint NOT NULL,
    activity_id character varying(50) NOT NULL,
    customer_id character varying(50) NOT NULL,
    contact_id character varying(50),
    opportunity_id character varying(50),
    trip_apply_id character varying(50),
    activity_type character varying(80) NOT NULL,
    activity_time timestamp with time zone NOT NULL,
    activity_location character varying(300),
    content text,
    customer_needs text,
    result text,
    next_follow_time timestamp with time zone,
    next_follow_plan text,
    owner_sales_id character varying(50),
    status character varying(30) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint NOT NULL,
    created_by_name character varying(100) NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by bigint,
    updated_by_name character varying(100)
);


--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.activity_id_seq OWNED BY business.activity.id;


--
-- Name: business_trip_apply; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.business_trip_apply (
    id bigint NOT NULL,
    apply_no character varying(80) NOT NULL,
    applicant_sales_id character varying(50) NOT NULL,
    customer_id character varying(50),
    opportunity_id character varying(50),
    destination_region_id bigint,
    destination character varying(300) NOT NULL,
    reason text NOT NULL,
    start_date date NOT NULL,
    end_date date NOT NULL,
    estimated_amount numeric(14,2) DEFAULT 0 NOT NULL,
    status character varying(30) DEFAULT 'draft'::character varying NOT NULL,
    approver_id bigint,
    approve_time timestamp with time zone,
    approve_remark text,
    attachment_url character varying(500),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    contact_id character varying(50)
);


--
-- Name: business_trip_apply_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.business_trip_apply_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: business_trip_apply_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.business_trip_apply_id_seq OWNED BY business.business_trip_apply.id;


--
-- Name: contact; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.contact (
    id bigint NOT NULL,
    contact_id character varying(50) NOT NULL,
    customer_id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    gender character varying(30),
    "position" character varying(120),
    department character varying(120),
    phone character varying(30),
    email character varying(120),
    wechat character varying(120),
    birthday date,
    preference text,
    is_primary boolean DEFAULT false NOT NULL,
    status character varying(30) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint NOT NULL,
    created_by_name character varying(100) NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by bigint,
    updated_by_name character varying(100)
);


--
-- Name: contact_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.contact_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contact_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.contact_id_seq OWNED BY business.contact.id;


--
-- Name: contract; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.contract (
    id bigint NOT NULL,
    contract_no character varying(80) NOT NULL,
    customer_id character varying(50) NOT NULL,
    opportunity_id character varying(50),
    quote_no character varying(80),
    amount numeric(14,2) DEFAULT 0 NOT NULL,
    start_date date,
    end_date date,
    attachment_url character varying(500),
    status character varying(30) DEFAULT 'draft'::character varying NOT NULL,
    owner_sales_id character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: contract_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.contract_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: contract_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.contract_id_seq OWNED BY business.contract.id;


--
-- Name: customer; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.customer (
    id bigint NOT NULL,
    customer_id character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    type character varying(80),
    source character varying(80),
    level character varying(80),
    industry character varying(120),
    phone character varying(30),
    province character varying(120),
    city character varying(120),
    district character varying(120),
    postal_code character varying(20),
    address character varying(500),
    owner_sales_id character varying(50),
    status character varying(30) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint NOT NULL,
    created_by_name character varying(100) NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by bigint,
    updated_by_name character varying(100)
);


--
-- Name: customer_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.customer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: customer_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.customer_id_seq OWNED BY business.customer.id;


--
-- Name: expense_apply; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.expense_apply (
    id bigint NOT NULL,
    expense_no character varying(80) NOT NULL,
    applicant_sales_id character varying(50) NOT NULL,
    trip_apply_no character varying(80),
    customer_id character varying(50),
    total_amount numeric(14,2) DEFAULT 0 NOT NULL,
    status character varying(30) DEFAULT 'draft'::character varying NOT NULL,
    approver_id bigint,
    approve_time timestamp with time zone,
    finance_user_id bigint,
    paid_time timestamp with time zone,
    remark text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: expense_apply_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.expense_apply_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expense_apply_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.expense_apply_id_seq OWNED BY business.expense_apply.id;


--
-- Name: expense_apply_item; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.expense_apply_item (
    id bigint NOT NULL,
    expense_apply_id bigint NOT NULL,
    expense_type character varying(80) NOT NULL,
    amount numeric(14,2) NOT NULL,
    occur_date date NOT NULL,
    description text,
    invoice_no character varying(120),
    attachment_url character varying(500)
);


--
-- Name: expense_apply_item_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.expense_apply_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expense_apply_item_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.expense_apply_item_id_seq OWNED BY business.expense_apply_item.id;


--
-- Name: opportunity; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.opportunity (
    id bigint NOT NULL,
    opportunity_id character varying(50) NOT NULL,
    customer_id character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    amount numeric(14,2) DEFAULT 0 NOT NULL,
    stage character varying(80) NOT NULL,
    win_rate numeric(5,2),
    expected_close_date date,
    owner_sales_id character varying(50),
    status character varying(30) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint NOT NULL,
    created_by_name character varying(100) NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by bigint,
    updated_by_name character varying(100)
);


--
-- Name: opportunity_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.opportunity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: opportunity_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.opportunity_id_seq OWNED BY business.opportunity.id;


--
-- Name: payment; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.payment (
    id bigint NOT NULL,
    payment_no character varying(80) NOT NULL,
    customer_id character varying(50) NOT NULL,
    contract_no character varying(80),
    order_no character varying(80),
    amount numeric(14,2) NOT NULL,
    payment_method character varying(80),
    payment_date date NOT NULL,
    owner_sales_id character varying(50),
    created_by bigint NOT NULL,
    created_by_name character varying(100) NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: payment_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.payment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payment_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.payment_id_seq OWNED BY business.payment.id;


--
-- Name: product; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.product (
    id bigint NOT NULL,
    product_code character varying(80) NOT NULL,
    product_name character varying(200) NOT NULL,
    category_id bigint,
    brand character varying(120),
    model character varying(120),
    unit character varying(40),
    standard_price numeric(14,2) DEFAULT 0 NOT NULL,
    cost_price numeric(14,2),
    tax_rate numeric(5,2),
    status character varying(30) DEFAULT 'enabled'::character varying NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: product_category; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.product_category (
    id bigint NOT NULL,
    category_code character varying(80) NOT NULL,
    category_name character varying(120) NOT NULL,
    parent_id bigint,
    sort_order integer DEFAULT 0 NOT NULL,
    status character varying(30) DEFAULT 'enabled'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: product_category_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.product_category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_category_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.product_category_id_seq OWNED BY business.product_category.id;


--
-- Name: product_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.product_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: product_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.product_id_seq OWNED BY business.product.id;


--
-- Name: quote; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.quote (
    id bigint NOT NULL,
    quote_no character varying(80) NOT NULL,
    customer_id character varying(50) NOT NULL,
    opportunity_id character varying(50),
    total_amount numeric(14,2) DEFAULT 0 NOT NULL,
    status character varying(30) DEFAULT 'draft'::character varying NOT NULL,
    created_by_sales_id character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: quote_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.quote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quote_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.quote_id_seq OWNED BY business.quote.id;


--
-- Name: quote_item; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.quote_item (
    id bigint NOT NULL,
    quote_id bigint NOT NULL,
    product_id bigint,
    product_code character varying(80) NOT NULL,
    product_name character varying(200) NOT NULL,
    unit character varying(40),
    quantity numeric(14,4) DEFAULT 1 NOT NULL,
    unit_price numeric(14,2) DEFAULT 0 NOT NULL,
    discount_rate numeric(5,2) DEFAULT 0 NOT NULL,
    tax_rate numeric(5,2),
    amount numeric(14,2) DEFAULT 0 NOT NULL
);


--
-- Name: quote_item_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.quote_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: quote_item_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.quote_item_id_seq OWNED BY business.quote_item.id;


--
-- Name: sales_cc_event; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.sales_cc_event (
    id bigint NOT NULL,
    event_no character varying(80) NOT NULL,
    event_type character varying(80) NOT NULL,
    title character varying(200) NOT NULL,
    related_type character varying(80),
    related_no character varying(120),
    sender_sales_id character varying(50),
    cc_sales_id character varying(50) NOT NULL,
    status character varying(30) DEFAULT 'unread'::character varying NOT NULL,
    occurred_at timestamp with time zone DEFAULT now() NOT NULL,
    remark text
);


--
-- Name: sales_cc_event_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.sales_cc_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_cc_event_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.sales_cc_event_id_seq OWNED BY business.sales_cc_event.id;


--
-- Name: sales_lead; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.sales_lead (
    id bigint NOT NULL,
    lead_no character varying(80) NOT NULL,
    lead_name character varying(200) NOT NULL,
    company_name character varying(200),
    contact_name character varying(100),
    phone character varying(30),
    email character varying(120),
    source character varying(80),
    status character varying(30) DEFAULT 'new'::character varying NOT NULL,
    rating character varying(30),
    owner_sales_id character varying(50),
    expected_amount numeric(14,2) DEFAULT 0 NOT NULL,
    next_follow_date date,
    remark text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    created_by bigint DEFAULT 0 NOT NULL,
    created_by_name character varying(100) DEFAULT 'system'::character varying NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_by bigint,
    updated_by_name character varying(100)
);


--
-- Name: sales_lead_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.sales_lead_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_lead_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.sales_lead_id_seq OWNED BY business.sales_lead.id;


--
-- Name: sales_order; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.sales_order (
    id bigint NOT NULL,
    order_no character varying(80) NOT NULL,
    customer_id character varying(50) NOT NULL,
    contract_no character varying(80),
    total_amount numeric(14,2) DEFAULT 0 NOT NULL,
    paid_amount numeric(14,2) DEFAULT 0 NOT NULL,
    delivery_status character varying(30),
    status character varying(30) DEFAULT 'pending'::character varying NOT NULL,
    owner_sales_id character varying(50),
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sales_order_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.sales_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_order_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.sales_order_id_seq OWNED BY business.sales_order.id;


--
-- Name: sales_order_item; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.sales_order_item (
    id bigint NOT NULL,
    order_id bigint NOT NULL,
    product_id bigint,
    product_name character varying(200) NOT NULL,
    product_code character varying(80) NOT NULL,
    unit character varying(40),
    quantity numeric(14,4) DEFAULT 1 NOT NULL,
    unit_price numeric(14,2) DEFAULT 0 NOT NULL,
    discount_rate numeric(5,2) DEFAULT 0 NOT NULL,
    tax_rate numeric(5,2),
    amount numeric(14,2) DEFAULT 0 NOT NULL
);


--
-- Name: sales_order_item_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.sales_order_item_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_order_item_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.sales_order_item_id_seq OWNED BY business.sales_order_item.id;


--
-- Name: sales_role; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.sales_role (
    id bigint NOT NULL,
    role_code character varying(80) NOT NULL,
    role_name character varying(120) NOT NULL,
    role_level integer DEFAULT 0 NOT NULL,
    description text,
    status character varying(30) DEFAULT 'enabled'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sales_role_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.sales_role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_role_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.sales_role_id_seq OWNED BY business.sales_role.id;


--
-- Name: sales_team; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.sales_team (
    id bigint NOT NULL,
    team_id character varying(50) NOT NULL,
    team_code character varying(80) NOT NULL,
    team_name character varying(120) NOT NULL,
    parent_team_id character varying(50),
    manager_sales_id character varying(50),
    region_id bigint,
    status character varying(30) DEFAULT 'active'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sales_team_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.sales_team_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_team_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.sales_team_id_seq OWNED BY business.sales_team.id;


--
-- Name: sales_user; Type: TABLE; Schema: business; Owner: -
--

CREATE TABLE business.sales_user (
    id bigint NOT NULL,
    sales_id character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    role_id bigint,
    role_name character varying(120),
    team_id character varying(50),
    first_line_manager_id character varying(50),
    second_line_manager_id character varying(50),
    phone character varying(30),
    email character varying(120),
    region_id bigint,
    status character varying(30) DEFAULT 'active'::character varying NOT NULL,
    entry_date date,
    leave_date date,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: sales_user_id_seq; Type: SEQUENCE; Schema: business; Owner: -
--

CREATE SEQUENCE business.sales_user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sales_user_id_seq; Type: SEQUENCE OWNED BY; Schema: business; Owner: -
--

ALTER SEQUENCE business.sales_user_id_seq OWNED BY business.sales_user.id;


--
-- Name: activity id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.activity ALTER COLUMN id SET DEFAULT nextval('business.activity_id_seq'::regclass);


--
-- Name: business_trip_apply id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.business_trip_apply ALTER COLUMN id SET DEFAULT nextval('business.business_trip_apply_id_seq'::regclass);


--
-- Name: contact id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.contact ALTER COLUMN id SET DEFAULT nextval('business.contact_id_seq'::regclass);


--
-- Name: contract id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.contract ALTER COLUMN id SET DEFAULT nextval('business.contract_id_seq'::regclass);


--
-- Name: customer id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.customer ALTER COLUMN id SET DEFAULT nextval('business.customer_id_seq'::regclass);


--
-- Name: expense_apply id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.expense_apply ALTER COLUMN id SET DEFAULT nextval('business.expense_apply_id_seq'::regclass);


--
-- Name: expense_apply_item id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.expense_apply_item ALTER COLUMN id SET DEFAULT nextval('business.expense_apply_item_id_seq'::regclass);


--
-- Name: opportunity id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.opportunity ALTER COLUMN id SET DEFAULT nextval('business.opportunity_id_seq'::regclass);


--
-- Name: payment id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.payment ALTER COLUMN id SET DEFAULT nextval('business.payment_id_seq'::regclass);


--
-- Name: product id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.product ALTER COLUMN id SET DEFAULT nextval('business.product_id_seq'::regclass);


--
-- Name: product_category id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.product_category ALTER COLUMN id SET DEFAULT nextval('business.product_category_id_seq'::regclass);


--
-- Name: quote id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.quote ALTER COLUMN id SET DEFAULT nextval('business.quote_id_seq'::regclass);


--
-- Name: quote_item id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.quote_item ALTER COLUMN id SET DEFAULT nextval('business.quote_item_id_seq'::regclass);


--
-- Name: sales_cc_event id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.sales_cc_event ALTER COLUMN id SET DEFAULT nextval('business.sales_cc_event_id_seq'::regclass);


--
-- Name: sales_lead id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.sales_lead ALTER COLUMN id SET DEFAULT nextval('business.sales_lead_id_seq'::regclass);


--
-- Name: sales_order id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.sales_order ALTER COLUMN id SET DEFAULT nextval('business.sales_order_id_seq'::regclass);


--
-- Name: sales_order_item id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.sales_order_item ALTER COLUMN id SET DEFAULT nextval('business.sales_order_item_id_seq'::regclass);


--
-- Name: sales_role id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.sales_role ALTER COLUMN id SET DEFAULT nextval('business.sales_role_id_seq'::regclass);


--
-- Name: sales_team id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.sales_team ALTER COLUMN id SET DEFAULT nextval('business.sales_team_id_seq'::regclass);


--
-- Name: sales_user id; Type: DEFAULT; Schema: business; Owner: -
--

ALTER TABLE ONLY business.sales_user ALTER COLUMN id SET DEFAULT nextval('business.sales_user_id_seq'::regclass);


--
-- Data for Name: activity; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.activity (id, activity_id, customer_id, contact_id, opportunity_id, trip_apply_id, activity_type, activity_time, activity_location, content, customer_needs, result, next_follow_time, next_follow_plan, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (1, 'A001', 'C001', 'CT001', NULL, NULL, '现场拜访', '2026-09-17 10:00:00+02', '上海市浦东新区', '拜访陈总，沟通企业版软件授权采购计划。', '希望统一销售过程、客户联系人和拜访记录。', '客户认可方案，要求补充报价。', '2026-09-19 09:30:00+02', '发送企业版软件授权和标准服务包报价。', 'S001', 'completed', '2026-09-17 13:22:48.590487+02', 0, 'system', '2026-09-17 13:37:39.086783+02', 0, 'system');
INSERT INTO business.activity (id, activity_id, customer_id, contact_id, opportunity_id, trip_apply_id, activity_type, activity_time, activity_location, content, customer_needs, result, next_follow_time, next_follow_plan, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (2, 'A002', 'C001', 'CT002', NULL, NULL, '技术交流', '2026-09-18 14:00:00+02', '线上会议', '与刘工评估数据迁移和实施周期。', '需要支持历史客户数据导入和每日全量备份。', '确认技术可行，待客户内部评审。', '2026-09-22 15:00:00+02', '提供实施计划和数据迁移清单。', 'S001', 'planned', '2026-09-17 13:22:48.590487+02', 0, 'system', '2026-09-17 13:37:39.086783+02', 0, 'system');
INSERT INTO business.activity (id, activity_id, customer_id, contact_id, opportunity_id, trip_apply_id, activity_type, activity_time, activity_location, content, customer_needs, result, next_follow_time, next_follow_plan, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (5, 'A005', 'C003', 'CT005', NULL, NULL, '线上会议', '2026-09-23 09:00:00+02', '线上会议', '与黄主任初步沟通医院客户管理需求。', '需要客户、联系人、拜访记录之间能追溯关联。', '客户希望下周安排现场演示。', '2026-09-28 14:00:00+02', '提交出差申请并预约现场演示。', 'S001', 'planned', '2026-09-17 13:22:48.590487+02', 0, 'system', '2026-09-17 13:37:39.086783+02', 0, 'system');
INSERT INTO business.activity (id, activity_id, customer_id, contact_id, opportunity_id, trip_apply_id, activity_type, activity_time, activity_location, content, customer_needs, result, next_follow_time, next_follow_plan, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (3, 'A003', 'C002', 'CT003', NULL, NULL, '现场拜访', '2026-09-20 11:00:00+02', '杭州市滨江区', '拜访周经理，了解制造项目销售管理需求。', '关注销售团队层级、一线经理、二线经理和报销审批。', '进入需求确认阶段。', '2026-09-24 10:00:00+02', '安排产品演示并确认审批流程。', 'S002', 'completed', '2026-09-17 13:22:48.590487+02', 0, 'system', '2026-09-17 13:37:39.087774+02', 0, 'system');
INSERT INTO business.activity (id, activity_id, customer_id, contact_id, opportunity_id, trip_apply_id, activity_type, activity_time, activity_location, content, customer_needs, result, next_follow_time, next_follow_plan, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (4, 'A004', 'C002', 'CT004', NULL, NULL, '电话沟通', '2026-09-21 16:30:00+02', '电话', '与孙会计确认报销和付款流程字段。', '需要财务人员可见报销付款，销售不可见财务页面。', '权限边界已确认。', '2026-09-25 10:30:00+02', '补充财务付款页面原型。', 'S002', 'completed', '2026-09-17 13:22:48.590487+02', 0, 'system', '2026-09-17 13:37:39.087774+02', 0, 'system');


--
-- Data for Name: business_trip_apply; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.business_trip_apply (id, apply_no, applicant_sales_id, customer_id, opportunity_id, destination_region_id, destination, reason, start_date, end_date, estimated_amount, status, approver_id, approve_time, approve_remark, attachment_url, created_at, updated_at, contact_id) VALUES (2, 'TR002', 'S001', 'C001', NULL, NULL, '上海市浦东新区', '与技术负责人评估数据迁移和现场实施方案', '2026-09-25', '2026-09-26', 2200.00, '已通过', NULL, NULL, '客户价值高，批准出差', NULL, '2026-09-17 13:37:39.089667+02', '2026-09-17 13:37:39.089667+02', 'CT002');
INSERT INTO business.business_trip_apply (id, apply_no, applicant_sales_id, customer_id, opportunity_id, destination_region_id, destination, reason, start_date, end_date, estimated_amount, status, approver_id, approve_time, approve_remark, attachment_url, created_at, updated_at, contact_id) VALUES (3, 'TR003', 'S002', 'C002', NULL, NULL, '杭州市滨江区', '现场沟通标准服务包和实施排期', '2026-09-28', '2026-09-29', 1600.00, '草稿', NULL, NULL, '销售本人草稿', NULL, '2026-09-17 13:37:39.089667+02', '2026-09-17 13:37:39.089667+02', 'CT003');
INSERT INTO business.business_trip_apply (id, apply_no, applicant_sales_id, customer_id, opportunity_id, destination_region_id, destination, reason, start_date, end_date, estimated_amount, status, approver_id, approve_time, approve_remark, attachment_url, created_at, updated_at, contact_id) VALUES (1, 'TR001', 'S001', 'C001', NULL, NULL, '上海市浦东新区', '拜访采购总监，确认企业版软件授权采购计划', '2026-09-20', '2026-09-21', 1800.00, '审批中', 3, NULL, '一线经理审批中', NULL, '2026-09-17 13:37:39.089667+02', '2026-10-04 05:42:47.838845+02', 'CT001');


--
-- Data for Name: contact; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.contact (id, contact_id, customer_id, name, gender, "position", department, phone, email, wechat, birthday, preference, is_primary, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (1, 'CT001', 'C001', '陈总', '男', '采购总监', '采购部', '13800000001', 'chen@example.com', 'chen_c001', NULL, NULL, true, 'active', '2026-09-17 13:22:48.586685+02', 0, 'system', '2026-09-17 13:22:48.586685+02', 0, 'system');
INSERT INTO business.contact (id, contact_id, customer_id, name, gender, "position", department, phone, email, wechat, birthday, preference, is_primary, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (2, 'CT002', 'C001', '刘工', '男', '技术负责人', '信息技术部', '13800000003', 'liu@example.com', 'liu_c001', NULL, NULL, false, 'active', '2026-09-17 13:22:48.586685+02', 0, 'system', '2026-09-17 13:22:48.586685+02', 0, 'system');
INSERT INTO business.contact (id, contact_id, customer_id, name, gender, "position", department, phone, email, wechat, birthday, preference, is_primary, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (3, 'CT003', 'C002', '周经理', '女', '项目经理', '项目管理部', '13800000002', 'zhou@example.com', 'zhou_c002', NULL, NULL, true, 'active', '2026-09-17 13:22:48.586685+02', 0, 'system', '2026-09-17 13:22:48.586685+02', 0, 'system');
INSERT INTO business.contact (id, contact_id, customer_id, name, gender, "position", department, phone, email, wechat, birthday, preference, is_primary, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (4, 'CT004', 'C002', '孙会计', '女', '财务主管', '财务部', '13800000004', 'sun@example.com', 'sun_c002', NULL, NULL, false, 'active', '2026-09-17 13:22:48.586685+02', 0, 'system', '2026-09-17 13:22:48.586685+02', 0, 'system');
INSERT INTO business.contact (id, contact_id, customer_id, name, gender, "position", department, phone, email, wechat, birthday, preference, is_primary, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (5, 'CT005', 'C003', '黄主任', '女', '信息科主任', '信息科', '13800000005', 'huang@example.com', 'huang_c003', NULL, NULL, true, 'active', '2026-09-17 13:22:48.586685+02', 0, 'system', '2026-09-17 13:22:48.586685+02', 0, 'system');


--
-- Data for Name: contract; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.contract (id, contract_no, customer_id, opportunity_id, quote_no, amount, start_date, end_date, attachment_url, status, owner_sales_id, created_at, updated_at) VALUES (1, 'CTR-CRM-001', 'C001', 'OP-CRM-001', NULL, 98000.00, '2026-09-22', '2027-09-22', NULL, 'active', 'S001', '2026-10-02 11:05:44.44832+02', '2026-10-02 11:05:44.44832+02');


--
-- Data for Name: customer; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.customer (id, customer_id, name, type, source, level, industry, phone, province, city, district, postal_code, address, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (3, 'C003', '深圳南山医院', '潜在客户', '官网咨询', 'A', '医疗健康', '0755-60000003', '广东省', '深圳市', '南山区', '518000', '深圳市南山区科技园 300 号', 'S001', 'active', '2026-09-17 13:22:48.579684+02', 0, 'system', '2026-09-17 13:37:39.085111+02', 0, 'system');
INSERT INTO business.customer (id, customer_id, name, type, source, level, industry, phone, province, city, district, postal_code, address, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (2, 'C002', '杭州启明制造', '意向客户', '客户转介绍', 'B', '智能制造', '0571-60000002', '浙江省', '杭州市', '滨江区', '310000', '杭州市滨江区江南大道 200 号', 'S002', 'active', '2026-09-17 13:22:48.579684+02', 0, 'system', '2026-09-17 13:37:39.086278+02', 0, 'system');
INSERT INTO business.customer (id, customer_id, name, type, source, level, industry, phone, province, city, district, postal_code, address, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (1, 'C001', '上海远景科技', '成交客户', '展会', 'A', '软件与信息服务', '021-60000001', '上海市', '上海市', '浦东新区', '200120', '上海市浦东新区世纪大道 100 号', 'S001', 'active', '2026-09-17 13:22:48.579684+02', 0, 'system', '2026-09-20 11:37:20.987732+02', 6, '系统管理员');


--
-- Data for Name: expense_apply; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.expense_apply (id, expense_no, applicant_sales_id, trip_apply_no, customer_id, total_amount, status, approver_id, approve_time, finance_user_id, paid_time, remark, created_at, updated_at) VALUES (7, 'EX003', 'S001', 'TR002', 'C001', 560.00, '已通过', NULL, NULL, NULL, NULL, '技术交流客户招待费', '2026-09-17 13:37:39.091853+02', '2026-09-17 13:37:39.091853+02');
INSERT INTO business.expense_apply (id, expense_no, applicant_sales_id, trip_apply_no, customer_id, total_amount, status, approver_id, approve_time, finance_user_id, paid_time, remark, created_at, updated_at) VALUES (8, 'EX004', 'S002', 'TR003', 'C002', 240.00, '草稿', NULL, NULL, NULL, NULL, '杭州客户拜访交通费', '2026-09-17 13:37:39.091853+02', '2026-09-17 13:37:39.091853+02');
INSERT INTO business.expense_apply (id, expense_no, applicant_sales_id, trip_apply_no, customer_id, total_amount, status, approver_id, approve_time, finance_user_id, paid_time, remark, created_at, updated_at) VALUES (6, 'EX002', 'S001', 'TR001', 'C001', 680.00, '待审批', 3, NULL, NULL, NULL, '上海客户拜访住宿费', '2026-09-17 13:37:39.091853+02', '2026-10-04 05:42:47.838845+02');
INSERT INTO business.expense_apply (id, expense_no, applicant_sales_id, trip_apply_no, customer_id, total_amount, status, approver_id, approve_time, finance_user_id, paid_time, remark, created_at, updated_at) VALUES (5, 'EX001', 'S001', 'TR001', 'C001', 320.00, '待审批', 3, NULL, NULL, NULL, NULL, '2026-09-17 13:37:39.091853+02', '2026-10-04 05:43:14.106309+02');


--
-- Data for Name: expense_apply_item; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.expense_apply_item (id, expense_apply_id, expense_type, amount, occur_date, description, invoice_no, attachment_url) VALUES (5, 5, '交通费', 320.00, '2026-09-20', '上海虹桥往返客户现场', 'INV-EX001', NULL);
INSERT INTO business.expense_apply_item (id, expense_apply_id, expense_type, amount, occur_date, description, invoice_no, attachment_url) VALUES (6, 6, '住宿费', 680.00, '2026-09-20', '浦东商务酒店一晚', 'INV-EX002', NULL);
INSERT INTO business.expense_apply_item (id, expense_apply_id, expense_type, amount, occur_date, description, invoice_no, attachment_url) VALUES (7, 7, '客户招待费', 560.00, '2026-09-25', '与技术负责人工作餐', 'INV-EX003', NULL);
INSERT INTO business.expense_apply_item (id, expense_apply_id, expense_type, amount, occur_date, description, invoice_no, attachment_url) VALUES (8, 8, '交通费', 240.00, '2026-09-28', '杭州东站至客户现场', 'INV-EX004', NULL);


--
-- Data for Name: opportunity; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.opportunity (id, opportunity_id, customer_id, name, amount, stage, win_rate, expected_close_date, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (1, 'OP-CRM-001', 'C001', '企业版 CRM 首期项目', 180000.00, '报价', 45.00, '2026-11-16', 'S001', 'active', '2026-10-02 11:05:44.44832+02', 0, 'seed', '2026-10-03 04:54:18.361408+02', 2, '张三');
INSERT INTO business.opportunity (id, opportunity_id, customer_id, name, amount, stage, win_rate, expected_close_date, owner_sales_id, status, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (3, 'OP-CRM-002', 'C002', '制造业销售管理项目', 156000.00, '需求确认', 35.00, '2026-12-02', 'S002', 'active', '2026-10-03 05:08:33.626465+02', 0, 'seed', '2026-10-03 05:08:33.626465+02', NULL, NULL);


--
-- Data for Name: payment; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.payment (id, payment_no, customer_id, contract_no, order_no, amount, payment_method, payment_date, owner_sales_id, created_by, created_by_name, created_at) VALUES (1, 'FIN001', 'C001', NULL, NULL, 30000.00, '银行转账', '2026-09-17', 'S001', 0, '赵财务', '2026-09-17 13:37:02.700017+02');
INSERT INTO business.payment (id, payment_no, customer_id, contract_no, order_no, amount, payment_method, payment_date, owner_sales_id, created_by, created_by_name, created_at) VALUES (3, 'FIN003', 'C003', NULL, NULL, 50000.00, '银行转账', '2026-09-19', 'S001', 0, '赵财务', '2026-09-17 13:37:02.700017+02');
INSERT INTO business.payment (id, payment_no, customer_id, contract_no, order_no, amount, payment_method, payment_date, owner_sales_id, created_by, created_by_name, created_at) VALUES (2, 'FIN002', 'C002', NULL, NULL, 118000.00, '银行转账', '2026-09-18', 'S002', 0, '赵财务', '2026-09-17 13:37:02.700017+02');


--
-- Data for Name: product; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.product (id, product_code, product_name, category_id, brand, model, unit, standard_price, cost_price, tax_rate, status, description, created_at, updated_at) VALUES (1, 'P001', '标准服务包', 2, '自有', 'STD', '套', 20000.00, 9000.00, 6.00, 'enabled', '标准实施和培训服务', '2026-09-17 13:37:02.690799+02', '2026-09-17 13:37:02.690799+02');
INSERT INTO business.product (id, product_code, product_name, category_id, brand, model, unit, standard_price, cost_price, tax_rate, status, description, created_at, updated_at) VALUES (2, 'P002', '企业版软件授权', 1, '自有', 'ENT-100', '年', 58000.00, 18000.00, 13.00, 'enabled', '销售管理系统企业版授权', '2026-09-17 13:37:02.690799+02', '2026-09-17 13:37:02.690799+02');
INSERT INTO business.product (id, product_code, product_name, category_id, brand, model, unit, standard_price, cost_price, tax_rate, status, description, created_at, updated_at) VALUES (3, 'P003', '现场实施服务', 2, '自有', 'IMPL', '人天', 2500.00, 1200.00, 6.00, 'enabled', '客户现场实施服务', '2026-09-17 13:37:02.690799+02', '2026-09-17 13:37:02.690799+02');
INSERT INTO business.product (id, product_code, product_name, category_id, brand, model, unit, standard_price, cost_price, tax_rate, status, description, created_at, updated_at) VALUES (4, 'P004', '数据迁移工具包', 3, '自有', 'DMT', '套', 12000.00, 5000.00, 13.00, 'disabled', '历史客户数据迁移工具', '2026-09-17 13:37:02.690799+02', '2026-09-17 13:37:02.690799+02');


--
-- Data for Name: product_category; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.product_category (id, category_code, category_name, parent_id, sort_order, status, created_at, updated_at) VALUES (1, 'software', '软件', NULL, 0, 'enabled', '2026-09-17 13:37:02.689958+02', '2026-09-17 13:37:02.689958+02');
INSERT INTO business.product_category (id, category_code, category_name, parent_id, sort_order, status, created_at, updated_at) VALUES (2, 'service', '服务', NULL, 0, 'enabled', '2026-09-17 13:37:02.689958+02', '2026-09-17 13:37:02.689958+02');
INSERT INTO business.product_category (id, category_code, category_name, parent_id, sort_order, status, created_at, updated_at) VALUES (3, 'tool', '工具', NULL, 0, 'enabled', '2026-09-17 13:37:02.689958+02', '2026-09-17 13:37:02.689958+02');


--
-- Data for Name: quote; Type: TABLE DATA; Schema: business; Owner: -
--



--
-- Data for Name: quote_item; Type: TABLE DATA; Schema: business; Owner: -
--



--
-- Data for Name: sales_cc_event; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.sales_cc_event (id, event_no, event_type, title, related_type, related_no, sender_sales_id, cc_sales_id, status, occurred_at, remark) VALUES (2, 'CC002', 'opportunity', '商机 OP001 阶段更新', 'opportunity', 'OP001', 'S002', 'S001', 'read', '2026-10-01 11:04:27.113553+02', '客户已确认演示时间');
INSERT INTO business.sales_cc_event (id, event_no, event_type, title, related_type, related_no, sender_sales_id, cc_sales_id, status, occurred_at, remark) VALUES (1, 'CC001', 'contract', '合同 CTR-2026-001 已提交归档', 'contract', 'CTR-2026-001', 'S002', 'S001', 'unread', '2026-10-02 09:04:27.113553+02', '请关注首付款到账');


--
-- Data for Name: sales_lead; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.sales_lead (id, lead_no, lead_name, company_name, contact_name, phone, email, source, status, rating, owner_sales_id, expected_amount, next_follow_date, remark, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (2, 'LD002', '渠道转介绍项目', '杭州星河贸易有限公司', '陈先生', '13800010002', 'chen@example.com', '渠道推荐', 'contacted', 'B', 'S001', 68000.00, '2026-10-07', '已电话沟通，等待预算确认', '2026-10-02 11:04:27.113553+02', 0, 'seed', '2026-10-02 11:04:27.113553+02', NULL, NULL);
INSERT INTO business.sales_lead (id, lead_no, lead_name, company_name, contact_name, phone, email, source, status, rating, owner_sales_id, expected_amount, next_follow_date, remark, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (1, 'LD001', '企业版 CRM 试用咨询', '上海云舟科技有限公司', '周女士', '13800010003', 'zhou@example.com', '官网表单', 'new', 'A', 'S001', 120000.00, '2026-10-04', '需要安排产品演示', '2026-10-02 11:04:27.113553+02', 0, 'seed', '2026-10-03 04:55:17.880697+02', 2, '张三');
INSERT INTO business.sales_lead (id, lead_no, lead_name, company_name, contact_name, phone, email, source, status, rating, owner_sales_id, expected_amount, next_follow_date, remark, created_at, created_by, created_by_name, updated_at, updated_by, updated_by_name) VALUES (10, 'LD003', '制造业数字化线索', '杭州启明制造', '孙女士', '13800010003', 'sun@example.com', '展会', 'qualified', 'A', 'S002', 156000.00, '2026-10-06', '关注销售流程自动化', '2026-10-03 05:08:33.626465+02', 0, 'seed', '2026-10-03 05:08:33.626465+02', NULL, NULL);


--
-- Data for Name: sales_order; Type: TABLE DATA; Schema: business; Owner: -
--



--
-- Data for Name: sales_order_item; Type: TABLE DATA; Schema: business; Owner: -
--



--
-- Data for Name: sales_role; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.sales_role (id, role_code, role_name, role_level, description, status, created_at, updated_at) VALUES (1, 'sales', '销售人员', 10, NULL, 'active', '2026-09-17 13:37:02.672203+02', '2026-09-17 13:37:02.672203+02');
INSERT INTO business.sales_role (id, role_code, role_name, role_level, description, status, created_at, updated_at) VALUES (2, 'first_manager', '一线经理', 20, NULL, 'active', '2026-09-17 13:37:02.672203+02', '2026-09-17 13:37:02.672203+02');
INSERT INTO business.sales_role (id, role_code, role_name, role_level, description, status, created_at, updated_at) VALUES (3, 'second_manager', '二线经理', 30, NULL, 'active', '2026-09-17 13:37:02.672203+02', '2026-09-17 13:37:02.672203+02');


--
-- Data for Name: sales_team; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.sales_team (id, team_id, team_code, team_name, parent_team_id, manager_sales_id, region_id, status, created_at, updated_at) VALUES (1, 'T001', 'EAST-01', '华东一组', NULL, 'M001', NULL, 'active', '2026-09-17 13:37:02.675696+02', '2026-09-17 13:37:39.083846+02');
INSERT INTO business.sales_team (id, team_id, team_code, team_name, parent_team_id, manager_sales_id, region_id, status, created_at, updated_at) VALUES (2, 'T002', 'EAST', '华东大区', NULL, 'D001', NULL, 'active', '2026-09-17 13:37:02.675696+02', '2026-09-17 13:37:39.084641+02');


--
-- Data for Name: sales_user; Type: TABLE DATA; Schema: business; Owner: -
--

INSERT INTO business.sales_user (id, sales_id, name, role_id, role_name, team_id, first_line_manager_id, second_line_manager_id, phone, email, region_id, status, entry_date, leave_date, created_at, updated_at) VALUES (3, 'S001', '张三', 1, '销售人员', 'T001', 'M001', 'D001', '13910000001', 'zhangsan@example.com', NULL, 'active', '2025-01-10', NULL, '2026-09-17 13:37:02.677591+02', '2026-09-17 13:37:39.077869+02');
INSERT INTO business.sales_user (id, sales_id, name, role_id, role_name, team_id, first_line_manager_id, second_line_manager_id, phone, email, region_id, status, entry_date, leave_date, created_at, updated_at) VALUES (4, 'S002', '李四', 1, '销售人员', 'T001', 'M001', 'D001', '13910000002', 'lisi@example.com', NULL, 'active', '2025-02-15', NULL, '2026-09-17 13:37:02.677591+02', '2026-09-17 13:37:39.077869+02');
INSERT INTO business.sales_user (id, sales_id, name, role_id, role_name, team_id, first_line_manager_id, second_line_manager_id, phone, email, region_id, status, entry_date, leave_date, created_at, updated_at) VALUES (2, 'M001', '李经理', 2, '一线经理', 'T001', 'D001', 'D001', '13910000003', 'manager@example.com', NULL, 'active', '2024-03-01', NULL, '2026-09-17 13:37:02.677591+02', '2026-09-17 13:37:39.081435+02');
INSERT INTO business.sales_user (id, sales_id, name, role_id, role_name, team_id, first_line_manager_id, second_line_manager_id, phone, email, region_id, status, entry_date, leave_date, created_at, updated_at) VALUES (1, 'D001', '王总监', 3, '二线经理', 'T002', 'D001', 'D001', '13910000004', 'director@example.com', NULL, 'active', '2024-01-01', NULL, '2026-09-17 13:37:02.677591+02', '2026-09-17 13:37:39.083139+02');


--
-- Name: activity_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.activity_id_seq', 10, true);


--
-- Name: business_trip_apply_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.business_trip_apply_id_seq', 3, true);


--
-- Name: contact_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.contact_id_seq', 10, true);


--
-- Name: contract_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.contract_id_seq', 15, true);


--
-- Name: customer_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.customer_id_seq', 7, true);


--
-- Name: expense_apply_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.expense_apply_id_seq', 8, true);


--
-- Name: expense_apply_item_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.expense_apply_item_id_seq', 8, true);


--
-- Name: opportunity_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.opportunity_id_seq', 29, true);


--
-- Name: payment_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.payment_id_seq', 16, true);


--
-- Name: product_category_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.product_category_id_seq', 6, true);


--
-- Name: product_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.product_id_seq', 8, true);


--
-- Name: quote_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.quote_id_seq', 1, false);


--
-- Name: quote_item_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.quote_item_id_seq', 1, false);


--
-- Name: sales_cc_event_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.sales_cc_event_id_seq', 34, true);


--
-- Name: sales_lead_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.sales_lead_id_seq', 49, true);


--
-- Name: sales_order_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.sales_order_id_seq', 1, false);


--
-- Name: sales_order_item_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.sales_order_item_id_seq', 1, false);


--
-- Name: sales_role_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.sales_role_id_seq', 6, true);


--
-- Name: sales_team_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.sales_team_id_seq', 4, true);


--
-- Name: sales_user_id_seq; Type: SEQUENCE SET; Schema: business; Owner: -
--

SELECT pg_catalog.setval('business.sales_user_id_seq', 8, true);


--
-- PostgreSQL database dump complete
--

\unrestrict g1iUYyLXRMmeYi2zYFVOX0lMXMOXiWS06x5IevTlgqkUxTHDEznjnWGNm6fCCbe

