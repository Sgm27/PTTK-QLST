1. Current project state
The registration form lives in `src/main/webapp/jsp/FillInformation.jsp`. The page renders the common header, shows the specification-required table `tblInputInformation`, and exposes `btnRegister` as the submit control. Validation feedback is shown through the shared `${errors}` attribute and individual field values are preserved with `${formData}`.

All HTTP traffic now flows through `com.qlst.servlet.RegisterServlet`. `GET /register` simply forwards to `FillInformation.jsp`. `POST /register` handles UTF-8 decoding, trims the submitted data, validates required fields, checks username/email uniqueness through `UserDAO`, hashes the password via `PasswordUtil`, and persists the request with `MemberDAO`. Success redirects to `/login?registered=true`, while validation errors are forwarded back to the JSP with context-aware messages.

`MemberDAO.saveInformation(Member)` keeps using a single JDBC connection (inherited from `DAO`) to wrap inserts into `tblUsers` and `tblCustomers` in one transaction. The `Member` entity holds id, name (used as username), password, email, address, and phone so it mirrors the UI contract. Other screens (login, statistics, etc.) already link to `/register`, ensuring a single entry point regardless of navigation path.

2. Target derived from the specification
- UI must capture the six data points (name, password, email, address, phone) in the table layout required by the document, keep HTML `required` where relevant, and re-display previously submitted values on errors.
- Form submissions must hit `/register`, not a JSP scriptlet, so that validation, hashing, and persistence all live in servlet/DAO layers.
- `MemberDAO` remains the transactional bridge that writes both the user account row (role `CUSTOMER`) and the associated customer profile.
- `Member`/`Customer` classes mirror the same field list that the form collects; optional values (address/phone) may be `null` when not provided.
- Navigation items across JSPs should highlight `currentPage == 'fillInformation'` but always link to `/register` for consistency.

3. Detailed implementation steps
Step 1: FillInformation.jsp
- Keep the view-only responsibilities in the JSP: branding header, table layout, `${errors}` list, and `${formData}` binding.
- Update the `<form>` tag to `action="${ctx}/register"` and use `method="post"` with `autocomplete="off"` as before.

Step 2: RegisterServlet
- Create `com.qlst.servlet.RegisterServlet` extending `HttpServlet`.
- `doGet` forwards to `/jsp/FillInformation.jsp`.
- `doPost` sets UTF-8 encoding, builds a `Member` instance for form echoing, performs field validations (empty fields, password length, email present), and queries `UserDAO.findByUsername` / `.findByEmail` to guard uniqueness.
- When validation fails, place `errors` and `formData` on the request scope and forward to the JSP; when it succeeds, hash the password and delegate to `MemberDAO.saveInformation`, handling SQL errors with logging plus user-friendly feedback.

Step 3: MemberDAO
- Reuse the existing transactional pattern (`con.setAutoCommit(false)`), insert into `tblUsers`, capture the generated key, and call `CustomerDAO.save`.
- Ensure helper methods (such as `insertUser` and `toCustomer`) stay private and lean, and remember to restore the original auto-commit flag.

Step 4: Member entity
- Keep the `String`-typed fields (`id`, `name`, `password`, `email`, `address`, `phone`) and expose the necessary getters/setters so JSP EL can access them directly.

Step 5: Customer entity
- Continue extending `Member` (if needed) and append registration-specific metadata like `userAccountId` and `joinedAt`.

Step 6: Web layer wiring
- Register the servlet inside `src/main/webapp/WEB-INF/web.xml` with a `<url-pattern>/register</url-pattern>`.
- Remove the legacy `DoSaveMember.jsp` and redirect every navigation link (`login.jsp`, `MainManagement.jsp`, statistics/customer views, etc.) to `/register`.
- Keep the `currentPage` flag as `fillInformation` for menu highlighting.

Step 7: Database scripts
- No new tables are required if `tblUsers` and `tblCustomers` already exist. When introducing a dedicated `members` table, extend the provisioning scripts (`script/create_tables.py`) and update `MemberDAO` accordingly.

Step 8: Testing
- Cover happy- and sad-path flows: POST empty fields, duplicate usernames/emails, success redirect to `/login`.
- Regression-test login using the freshly created account to confirm credentials were hashed properly and relationships were stored in both tables.

4. Completion checklist
- `FillInformation.jsp` renders the spec-compliant form and posts to `/register`.
- `RegisterServlet` performs validation, hashing, uniqueness checks, and persistence before redirecting or forwarding.
- `MemberDAO` and entities stay aligned with the UI contract.
- Every navigation link points to `/register`; no JSP performs business logic for registration.
- Manual or automated tests confirm both the registration and subsequent login flows.
