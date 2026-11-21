# ACCEPTANCE.md

# Form validation: acceptance criteria

1. Given no score is selected, when I tap Save entry, then the message
   "Choose a score from 1 to 10" appears and nothing is added to the history.
2. Given a 2001 characters notes and a score is selected, when I tap save entry, then the menssage
    "Notes may be at most 2000 characters" appears and nothing is added to the history.
3. Given a 2000 characters notes and a score is selected, when I tap save entry, then the entry must be saved and it's added to the history
4. Given the note error is shown, when I shorten the note to 2000 characters or fewer and tap Save entry, then the error disappears and the entry is added
5. When no note is given, then the entry is saved with only the score 
6. Given a score and a valid note is typed, when I tape Save entry, then the entry is added to the history, and the form remains with no selected chip and the note empty
