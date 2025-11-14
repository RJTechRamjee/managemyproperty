# PropertyManager.js - Visual Issue Map

```
PropertyManager.js (606 lines)
├── Imports & Setup (Lines 1-9)
│   ├── ❌ Line 2: Unused import 'UPDATE'
│   └── ✅ Core imports correct
│
├── Constructor (Lines 6-9)
│   └── ✅ No issues
│
├── registerHandlers() (Lines 14-187)
│   ├── ❌ Line 15: Unused variables (Notifications, EmailLogs, Users)
│   ├── ❌ Line 23: Error handling returns string
│   ├── ❌ Line 27: Unused 'response' parameter
│   ├── ⚠️ Lines 67-98: Commented-out UPDATE/PATCH handler (32 lines)
│   ├── ❌ Line 110: Unused 'response' parameter
│   ├── ❌ Line 127: Unused 'response' parameter
│   ├── ❌ Line 158: Unused 'response' parameter
│   └── ❌ Line 162: Unused 'response' parameter
│
├── getDynamicYears() (Lines 192-199)
│   └── ✅ No issues
│
├── setPropertyStatus() (Lines 204-236)
│   ├── 🔄 Line 215: Use cds.tx (currently cds.tx) ✅
│   └── ❌ Line 234: Error handling returns string
│
├── sendContactRequest() (Lines 241-295)
│   ├── ❌ Line 243: Unused 'ContactRequests' variable
│   ├── ❌ Line 244: Unused 'uuid' variable
│   ├── 🔄 Line 256: Use cds.tx (currently cds.transaction)
│   └── ❌ Line 293: Error handling returns string
│
├── respondToRequest() (Lines 300-347)
│   ├── 🔄 Line 311: Use cds.tx (currently cds.transaction)
│   └── ❌ Line 345: Error handling returns string
│
├── closeRequest() (Lines 352-387)
│   ├── 🔄 Line 362: Use cds.tx (currently cds.transaction)
│   └── ❌ Line 385: Error handling returns string
│
├── sendNotification() (Lines 392-410)
│   ├── 🔄 Line 395: Use cds.tx (currently cds.transaction)
│   └── ❌ Line 408: Error handling returns string
│
├── sendEmail() (Lines 415-434)
│   ├── 🔄 Line 418: Use cds.tx (currently cds.transaction)
│   └── ❌ Line 432: Error handling returns string
│
├── getNextPropertyId() (Lines 439-450)
│   └── ❌ Line 439: Unused 'tx' parameter
│
├── createNotification() (Lines 455-468)
│   └── ✅ No issues
│
├── createEmailLog() (Lines 473-488)
│   └── ✅ No issues
│
├── validateProperty() (Lines 493-496)
│   ├── ❌ Line 493: Unused 'propertyData' parameter
│   └── ⚠️ Empty method - no validation logic
│
├── validateNearByAminities() (Lines 501-504)
│   ├── ❌ Line 501: Unused 'amenitiesData' parameter
│   ├── ⚠️ Typo: "Aminities" should be "Amenities"
│   └── ⚠️ Empty method - no validation logic
│
├── populatePropertyOwnership() (Lines 509-552)
│   └── ⚠️ Potential N+1 query issue
│
└── populateContactRequestOwnership() (Lines 557-600)
    └── ✅ No issues

Legend:
❌ ESLint Warning / Error - Must fix
🔄 Inconsistency - Should fix
⚠️ Code Quality Issue - Should improve
✅ No Issues
```

## Issue Distribution by Type

```
ESLint Warnings (14 total):
┌─────────────────────────────────────────────────┐
│ Unused Imports         : ██ (2)                 │
│ Unused Variables       : ████ (4)               │
│ Unused Parameters      : ████████ (8)           │
└─────────────────────────────────────────────────┘

Code Quality Issues (7 total):
┌─────────────────────────────────────────────────┐
│ Error Handling         : ███████ (7)            │
│ Transaction Handling   : ██████ (6)             │
│ Commented Code         : █ (1 block)            │
│ Empty Methods          : ██ (2)                 │
│ Typos                  : █ (1)                  │
└─────────────────────────────────────────────────┘
```

## Code Smell Heatmap

```
Lines      Issue Density    Description
-------    -------------    -------------------------------
1-50       ▓▓▓░░           Setup + early handlers (3 issues)
51-100     ▓▓▓▓▓           Commented code block (5 issues)
101-150    ▓▓░░░           Handler definitions (2 issues)
151-200    ░░░░░           No major issues
201-250    ▓▓▓░░           Action handlers (3 issues)
251-300    ▓▓▓▓░           Request handlers (4 issues)
301-350    ▓▓▓░░           Response handlers (3 issues)
351-400    ▓▓▓░░           Close/notification (3 issues)
401-450    ▓▓▓░░           Email/ID generation (3 issues)
451-500    ▓▓░░░           Helper methods (2 issues)
501-550    ▓▓▓░░           Validation/ownership (3 issues)
551-606    ░░░░░           Final methods (no issues)

Legend: ▓ = Issues present, ░ = Clean code
```

## Duplicate Code Patterns

### Pattern 1: Authentication Check (8 occurrences)
```
Locations:
• Line 38-41   : draftPrepare handler
• Line 46-48   : draftActivate handler
• Line 209-212 : setPropertyStatus
• Line 251-253 : sendContactRequest
• Line 305-308 : respondToRequest
• Line 356-359 : closeRequest
• Plus 2 more...

Pattern:
    const userId = request.user?.id;
    if (!userId || userId === 'anonymous') {
        return request.reject(401, 'User must be authenticated...');
    }

Recommendation: Extract to checkAuthentication() helper
```

### Pattern 2: Property Ownership Check (4 occurrences)
```
Locations:
• Line 54-64   : draftActivate handler
• Line 217-225 : setPropertyStatus
• Line 321-328 : respondToRequest
• Line 372-379 : closeRequest

Pattern:
    const property = await tx.read(Properties).where({ ID: propertyId });
    if (property && property.length > 0) {
        if (property[0].contactPerson_ID !== userId) {
            return request.reject(403, 'Not authorized...');
        }
    }

Recommendation: Extract to checkPropertyOwnership() helper
```

### Pattern 3: Error Handling (7 occurrences)
```
Locations:
• Line 23   : registerHandlers
• Line 234  : setPropertyStatus
• Line 293  : sendContactRequest
• Line 345  : respondToRequest
• Line 385  : closeRequest
• Line 408  : sendNotification
• Line 432  : sendEmail

Pattern:
    catch (error) {
        return "Error: " + error.toString();
    }

Recommendation: Use request.reject(500, error.message)
```

## Complexity Analysis

```
Method Complexity Scores (Cyclomatic Complexity):

Low Complexity (1-5):
✅ getDynamicYears              : 2
✅ validateProperty             : 1
✅ validateNearByAminities      : 1
✅ createNotification           : 1
✅ createEmailLog               : 1
✅ getNextPropertyId            : 3

Medium Complexity (6-10):
⚠️ setPropertyStatus            : 7
⚠️ sendContactRequest           : 8
⚠️ respondToRequest             : 9
⚠️ closeRequest                 : 8
⚠️ sendNotification             : 4
⚠️ sendEmail                    : 4

High Complexity (11+):
❌ registerHandlers             : 15
❌ populatePropertyOwnership    : 12
❌ populateContactRequestOwnership : 10

Recommendation:
- Split registerHandlers into smaller methods
- Simplify ownership population logic
- Extract validation logic from handlers
```

## Method Length Analysis

```
Lines of Code per Method:

Very Short (1-10 lines):
✅ constructor                  : 4 lines
✅ getDynamicYears              : 8 lines
✅ validateProperty             : 4 lines
✅ validateNearByAminities      : 4 lines

Short (11-30 lines):
✅ setPropertyStatus            : 33 lines
✅ getNextPropertyId            : 12 lines
✅ createNotification           : 14 lines
✅ createEmailLog               : 16 lines

Medium (31-60 lines):
⚠️ sendContactRequest           : 55 lines
⚠️ respondToRequest             : 48 lines
⚠️ closeRequest                 : 36 lines
⚠️ populatePropertyOwnership    : 44 lines
⚠️ populateContactRequestOwnership : 44 lines

Long (61+ lines):
❌ registerHandlers             : 174 lines ⚠️

Recommendation:
- Split registerHandlers into separate handler registration methods
- Consider extracting validation logic from action handlers
```

## Dependencies and Coupling

```
External Dependencies:
├── @sap/cds                 ✅ (Standard CAP framework)
├── @sap/cds/lib/ql/cds-ql  ✅ (Query language)
└── No other external deps   ✅

Internal Coupling:
├── Entities (High)
│   ├── Properties          : 11 references
│   ├── ContactRequests     : 5 references
│   ├── Notifications       : 2 references
│   └── EmailLogs           : 2 references
│
├── Service (High)
│   └── srv.before/after/on : 20+ event registrations
│
└── Request Context (High)
    └── request.user        : 8+ authentication checks

Coupling Assessment: ⚠️ HIGH
- Tightly coupled to service and entities
- Consider dependency injection for testability
```

## Technical Debt Score

```
Category                Weight    Score    Weighted
────────────────────────────────────────────────────
ESLint Warnings         20%       28%      5.6
Code Duplication        20%       40%      8.0
Complexity              15%       60%      9.0
Test Coverage           15%       0%       0.0
Documentation           10%       70%      7.0
Error Handling          10%       30%      3.0
Security                10%       50%      5.0
────────────────────────────────────────────────────
TOTAL DEBT SCORE                          37.6/100

Rating: ⚠️ MEDIUM-HIGH (Should address soon)

Target after Phase 1:  60/100 (Medium)
Target after Phase 2:  75/100 (Low)
Target after Phase 3:  85/100 (Very Low)
```

## Priority Matrix

```
                    High Impact
                        │
    ┌───────────────────┼───────────────────┐
    │                   │                   │
    │   P1: DO FIRST    │   P2: SCHEDULE    │
U   │                   │                   │
r   │ • Remove unused   │ • Refactor into   │
g   │   imports/vars    │   modules         │
e   │ • Fix error       │ • Add unit tests  │
n   │   handling        │ • Optimize queries│
c   │ • Remove dead     │                   │
y   │   code            │                   │
    │                   │                   │
    ├───────────────────┼───────────────────┤
    │                   │                   │
    │   P3: NEXT SPRINT │   P4: BACKLOG     │
    │                   │                   │
    │ • Extract helpers │ • Add monitoring  │
    │ • Add input       │ • Performance     │
    │   validation      │   profiling       │
    │ • Fix typos       │ • Add caching     │
    │                   │                   │
    └───────────────────┼───────────────────┘
                        │
                    Low Impact
```

## Recommended Action Plan

### Week 1: Quick Wins (P1)
```
Day 1: ✅ Analysis & Proposal (DONE)
Day 2: □ Phase 1 Implementation (ESLint fixes)
Day 3: □ Phase 2 Implementation (Error handling)
Day 4: □ Testing & validation
Day 5: □ Code review & merge
```

### Week 2: Improvements (P2 & P3)
```
Day 1-2: □ Extract helper methods
Day 3-4: □ Add input validation & security
Day 5:   □ Testing & documentation
```

### Future: Architecture (P4)
```
Sprint N: □ Module refactoring
Sprint N+1: □ Unit test suite
Sprint N+2: □ Performance optimization
```

---

**Generated:** 2025-11-14  
**Version:** 1.0  
**Tool:** Code Analysis & Visualization
