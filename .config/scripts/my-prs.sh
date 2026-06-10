#!/usr/bin/env bash
set -euo pipefail

gh pr list --author=@me --json number,title,statusCheckRollup,url,reviews,reviewDecision | jq -r '
  .[] |
  .number as $num |
  .title as $title |
  .url as $url |
  .statusCheckRollup as $checks |
  .reviews as $reviews |
  .reviewDecision as $decision |

  ($checks | map(select(.status == "IN_PROGRESS" or .status == "QUEUED")) | length) as $pending |
  ($checks | map(select(.conclusion == "FAILURE" or .conclusion == "TIMED_OUT" or .conclusion == "CANCELLED")) | length) as $failed |
  ($checks | map(select(.conclusion == "SUCCESS")) | length) as $passed |
  ($checks | map(select(.conclusion == "SKIPPED")) | length) as $skipped |

  ($reviews | map(select(.state == "APPROVED")) | unique_by(.author.login) | length) as $approvals |
  ($reviews | map(select(.state == "CHANGES_REQUESTED")) | unique_by(.author.login) | length) as $changes_requested |

  (if $failed > 0 then "✗ FAILING"
   elif $pending > 0 then "⧗ PENDING"
   elif ($checks | length) == 0 then "- NO CHECKS"
   else "✓ PASSING"
   end) as $overall |

  (if $decision == "APPROVED" then "✓ APPROVED"
   elif $decision == "CHANGES_REQUESTED" then "✗ CHANGES REQUESTED"
   elif $decision == "REVIEW_REQUIRED" then "⧗ REVIEW REQUIRED"
   else "- NO DECISION"
   end) as $review_status |

  "PR #\($num)  \($overall)  \($review_status)",
  "  \($title)",
  "  \($url)",
  "  checks: \($passed) passed  \($failed) failed  \($pending) pending  \($skipped) skipped",
  "  reviews: \($approvals) approval(s)\(if $changes_requested > 0 then "  \($changes_requested) changes requested" else "" end)",
  (if $failed > 0 then
    "  failing:",
    ($checks | map(select(.conclusion == "FAILURE" or .conclusion == "TIMED_OUT")) | .[] | "    - \(.name) [\(.workflowName)]")
   else empty end),
  ""
'
