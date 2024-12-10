This repo is part of the [Advanced dbt-GA4 course](https://caretjuice.com/courses/advanced-dbt-ga4/) from Caret Juice Data Ltd.

It's not intended to be usable on its own. If you are looking for free dbt and dbt-GA4 training, check out the [dbt-GA4 Setup course](https://caretjuice.com/courses/intro-to-dbt-ga4-on-demand/).

## Implementation 03 Review End

This branch, `imp-03-review-end`, takes you to the end of the review section of the second lesson of Advanced dbt-GA4 Implementation.

By the end of this lesson, you should have enabled staging event models from the dbt-GA4 package and built your own custom event staging models as needed. Obviously, the events that you enable or create will differ from the ones that I do in the lesson.

## Course, Lesson, Section Branching Structure

The course is divided in to sections. At launch, these are Implementation and Business but there are plans to add Debugging and GitHub Actions. The Business section does not have code so only the Implementation section has branches in this repo at launch. These are identified by the `imp-` prefix.

The lessons in the Implementation and Business sections are numbered sequentially. The middle number of the branch identifies the lesson number within that section so `imp-01` is the first lesson of of the Implementation section.

Each lesson is divided into sections: review, instruct, practice, and expand. Each branch represents the state of the lesson at the end of the section and is labeled with the `-end` suffix.

Review, `imp-XX-review-end`, takes you to the end of the Review section of the lesson. The Review section covers **relevant knowledge from previous lessons** in this course and from dbt-GA4 Setup ensuring that the knowledge that you need to progress is fresh. Some important setup steps are completed in the Review section of a lesson.

Instruct,`imp-XX-instruct-end`, takes you to the end of the main Instruction section. This is typically a mix of text and video where we introduce new concepts.

Practice, `imp-xx-practice-end`, takes you to the end of the Practice section. The Practice section is where you apply the instruction from the main Lesson section.

Expansion, `imp-xx-expand-end`, takes you to the end of the Expansion section. The Expansion section is more free-form than the Practice section. In it, you will use the knowledge from the Lesson section in a wider context. It will draw on knowledge from previous lessons and from the dbt-GA4 Setup course. You will also be expected to do some additional reading and research to complete this section. The Business portion of the course does not have Expansion sections in its lessons.

Lesson end, `imp-xx-end`, will be a duplicate of the last branch, so usually Expansion, but is included for clarity.