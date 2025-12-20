class OfflineQuestionBank {
  static const List<Map<String, dynamic>> personalityQuestions = [
    // --- E/I Questions (Extroversion vs Introversion) ---
    {
      "question": "At a crowded party, do you usually...",
      "subtitle": "Social Energy Check",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "Talk to everyone, including strangers",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "Stick to your close friends",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "Leave early to recharge alone",
          "scores": {"I": 2}
        },
        {
          "label": "D",
          "text": "Host and entertain the crowd",
          "scores": {"E": 2}
        }
      ]
    },
    {
      "question": "After a long, stressful week, you prefer to:",
      "subtitle": "Recharge Method",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "Go out with a big group of friends",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "Read a book or watch a movie alone",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "Attend a loud concert or event",
          "scores": {"E": 2}
        },
        {
          "label": "D",
          "text": "Work on a solo hobby project",
          "scores": {"I": 2}
        }
      ]
    },
    {
      "question": "In conversations, you tend to:",
      "subtitle": "Communication Style",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "Do most of the talking",
          "scores": {"E": 1}
        },
        {
          "label": "B",
          "text": "Listen more than you speak",
          "scores": {"I": 1}
        },
        {
          "label": "C",
          "text": "Think before you speak",
          "scores": {"I": 1}
        },
        {
          "label": "D",
          "text": "Think out loud",
          "scores": {"E": 1}
        }
      ]
    },
    {
      "question": "When meeting new people, you:",
      "subtitle": "Initial Interaction",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "Feel energized and excited",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "Feel somewhat drained",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "Wait for them to approach you",
          "scores": {"I": 1}
        },
        {
          "label": "D",
          "text": "Introduce yourself immediately",
          "scores": {"E": 2}
        }
      ]
    },
    {
      "question": "Your ideal workspace is:",
      "subtitle": "Work Environment",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "A bustling open office",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "A quiet private room",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "A busy cafe",
          "scores": {"E": 1}
        },
        {
          "label": "D",
          "text": "Your secluded bedroom",
          "scores": {"I": 1}
        }
      ]
    },
    {
      "question": "If your phone rings unexpectedly, you:",
      "subtitle": "Spontaneous Interaction",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "Answer it immediately",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "Watch it ring and text back later",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "Feel annoying interruption",
          "scores": {"I": 1}
        },
        {
          "label": "D",
          "text": "Hope it's good news",
          "scores": {"E": 1}
        }
      ]
    },
    {
      "question": "You make decisions:",
      "subtitle": "Decision Processing",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "By discussing them with others",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "By reflecting internally first",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "After asking for advice",
          "scores": {"E": 1}
        },
        {
          "label": "D",
          "text": "After sleeping on it",
          "scores": {"I": 1}
        }
      ]
    },
    {
      "question": "In a group project, you are the one who:",
      "subtitle": "Group Role",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "Leads the discussion",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "Does the research quietly",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "Organizes the team",
          "scores": {"E": 1}
        },
        {
          "label": "D",
          "text": "Edits the final work",
          "scores": {"I": 1}
        }
      ]
    },
    {
      "question": "When walking into a room full of strangers:",
      "subtitle": "Social Confidence",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "You scan for someone to talk to",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "You look for a corner or exit",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "You wait for someone to notice you",
          "scores": {"I": 1}
        },
        {
          "label": "D",
          "text": "You make a grand entrance",
          "scores": {"E": 2}
        }
      ]
    },
    {
      "question": "Your friends would describe you as:",
      "subtitle": "Social Perception",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "The life of the party",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "A thoughtful listener",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "The planner",
          "scores": {"E": 1}
        },
        {
          "label": "D",
          "text": "The mysterious one",
          "scores": {"I": 1}
        }
      ]
    },

    // --- S/N Questions (Sensing vs Intuition) ---
    {
      "question": "When learning something new, you prefer:",
      "subtitle": "Learning Style",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Concrete facts and data",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "Concepts and theories",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "Hands-on experience",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "Thinking about the big picture",
          "scores": {"N": 1}
        }
      ]
    },
    {
      "question": "You focus more on:",
      "subtitle": "Focus Area",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "The present reality",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "Future possibilities",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "Details and specifics",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "Patterns and meanings",
          "scores": {"N": 1}
        }
      ]
    },
    {
      "question": "In your opinion, it is worse to be:",
      "subtitle": "Value Judgment",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Identifying patterns everyone else misses",
          "scores": {"N": 1}
        },
        {
          "label": "B",
          "text": "Head in the clouds",
          "scores": {"S": 1}
        },
        {
          "label": "C",
          "text": "Stuck in a rut",
          "scores": {"N": 1}
        },
        {
          "label": "D",
          "text": "Unrealistic",
          "scores": {"S": 1}
        }
      ]
    },
    {
      "question": "Do you trust:",
      "subtitle": "Trust Basis",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Your direct experience",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "Your gut instinct",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "What is proven to work",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "Inspiration and hunches",
          "scores": {"N": 1}
        }
      ]
    },
    {
      "question": "When describing an event, you:",
      "subtitle": "Description Style",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Stick to exactly what happened",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "Describe the vibe and impression",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "Focus on the physical details",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "Focus on the meaning",
          "scores": {"N": 1}
        }
      ]
    },
    {
      "question": "You are more interested in:",
      "subtitle": "Interest Focus",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "What is actual",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "What is possible",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "Production and utility",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "Design and invention",
          "scores": {"N": 1}
        }
      ]
    },
    {
      "question": "You prefer instructions that are:",
      "subtitle": "Instruction Preference",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Step-by-step",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "A general overview",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "Clear and literal",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "Open to interpretation",
          "scores": {"N": 1}
        }
      ]
    },
    {
      "question": "When you look at a painting, you see:",
      "subtitle": "Perception",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Colors and brushstrokes",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "The deeper meaning",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "The technique used",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "The emotion conveyed",
          "scores": {"N": 1}
        }
      ]
    },
    {
      "question": "You consider yourself:",
      "subtitle": "Self-Identity",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Practical",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "Imaginative",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "Down-to-earth",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "innovative",
          "scores": {"N": 1}
        }
      ]
    },
    {
      "question": "Standard procedures are:",
      "subtitle": "View on Rules",
      "dimension": "S/N",
      "options": [
        {
          "label": "A",
          "text": "Useful and necessary",
          "scores": {"S": 2}
        },
        {
          "label": "B",
          "text": "Often boring and limiting",
          "scores": {"N": 2}
        },
        {
          "label": "C",
          "text": "Safe guidelines",
          "scores": {"S": 1}
        },
        {
          "label": "D",
          "text": "A starting point to deviate from",
          "scores": {"N": 1}
        }
      ]
    },

    // --- T/F Questions (Thinking vs Feeling) ---
    {
      "question": "When making a difficult decision, you rely on:",
      "subtitle": "Decision Basis",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Logic and consistency",
          "scores": {"T": 2}
        },
        {
          "label": "B",
          "text": "People's feelings and harmony",
          "scores": {"F": 2}
        },
        {
          "label": "C",
          "text": "Pros and cons list",
          "scores": {"T": 1}
        },
        {
          "label": "D",
          "text": "How it aligns with your values",
          "scores": {"F": 1}
        }
      ]
    },
    {
      "question": "Is it more of a compliment to be called:",
      "subtitle": "Compliment Preference",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "A very logical person",
          "scores": {"T": 2}
        },
        {
          "label": "B",
          "text": "A very sentimental person",
          "scores": {"F": 2}
        },
        {
          "label": "C",
          "text": "Competent",
          "scores": {"T": 1}
        },
        {
          "label": "D",
          "text": "Compassionate",
          "scores": {"F": 1}
        }
      ]
    },
    {
      "question": "In a disagreement, you prioritize:",
      "subtitle": "Conflict Resolution",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Being right and truthful",
          "scores": {"T": 2}
        },
        {
          "label": "B",
          "text": "Finding a compromise",
          "scores": {"F": 2}
        },
        {
          "label": "C",
          "text": "Analysing the argument",
          "scores": {"T": 1}
        },
        {
          "label": "D",
          "text": "Understanding the other's feelings",
          "scores": {"F": 1}
        }
      ]
    },
    {
      "question": "You are more likely to:",
      "subtitle": "General Disposition",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Critique something honestly",
          "scores": {"T": 1}
        },
        {
          "label": "B",
          "text": "Appreciate something subjectively",
          "scores": {"F": 1}
        },
        {
          "label": "C",
          "text": "Look for flaws to fix",
          "scores": {"T": 2}
        },
        {
          "label": "D",
          "text": "Look for beauty to admire",
          "scores": {"F": 2}
        }
      ]
    },
    {
      "question": "When a friend is sad, you:",
      "subtitle": "Comforting Style",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Help them solve the problem",
          "scores": {"T": 2}
        },
        {
          "label": "B",
          "text": "Sympathize and listen",
          "scores": {"F": 2}
        },
        {
          "label": "C",
          "text": "Analyze why it happened",
          "scores": {"T": 1}
        },
        {
          "label": "D",
          "text": "Give them a hug",
          "scores": {"F": 1}
        }
      ]
    },
    {
      "question": "You believe fairness means:",
      "subtitle": "Justice",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Treating everyone equally",
          "scores": {"T": 2}
        },
        {
          "label": "B",
          "text": "Treating everyone according to need",
          "scores": {"F": 2}
        },
        {
          "label": "C",
          "text": "Following the rules",
          "scores": {"T": 1}
        },
        {
          "label": "D",
          "text": "Being kind",
          "scores": {"F": 1}
        }
      ]
    },
    {
      "question": "Which creates more problems?",
      "subtitle": "Worldview",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Being too emotional",
          "scores": {"T": 2}
        },
        {
          "label": "B",
          "text": "Being too cold/analytical",
          "scores": {"F": 2}
        },
        {
          "label": "C",
          "text": "Lack of logic",
          "scores": {"T": 1}
        },
        {
          "label": "D",
          "text": "Lack of empathy",
          "scores": {"F": 1}
        }
      ]
    },
    {
      "question": "You are more persuaded by:",
      "subtitle": "Persuasion",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "A strong logical argument",
          "scores": {"T": 2}
        },
        {
          "label": "B",
          "text": "A touching story",
          "scores": {"F": 2}
        },
        {
          "label": "C",
          "text": "Examples and evidence",
          "scores": {"T": 1}
        },
        {
          "label": "D",
          "text": "Human impact",
          "scores": {"F": 1}
        }
      ]
    },
    {
      "question": "Winning a debate is:",
      "subtitle": "Competition",
      "dimension": "T/F",
      "options": [
        {
          "label": "A",
          "text": "Important to establish truth",
          "scores": {"T": 2}
        },
        {
          "label": "B",
          "text": "Less important than feelings",
          "scores": {"F": 2}
        },
        {
          "label": "C",
          "text": "Satisfying",
          "scores": {"T": 1}
        },
        {
          "label": "D",
          "text": "Uncomfortable if it hurts someone",
          "scores": {"F": 1}
        }
      ]
    },

    // --- J/P Questions (Judging vs Perceiving) ---
    {
      "question": "How do you handle deadlines?",
      "subtitle": "Work Style",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Plan ahead and finish early",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "Wait for the last-minute rush",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "create a schedule and stick to it",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "Panic but get it done",
          "scores": {"P": 1}
        }
      ]
    },
    {
      "question": "Your workspace is usually:",
      "subtitle": "Organization",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Organized and tidy",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "Cluttered but you know where things are",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "Systematic",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "Chaotic",
          "scores": {"P": 1}
        }
      ]
    },
    {
      "question": "When planning a trip, you prefer:",
      "subtitle": "Travel Style",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "A detailed itinerary",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "To go with the flow",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "Knowing exactly where you'll stay",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "Discovering places as you go",
          "scores": {"P": 1}
        }
      ]
    },
    {
      "question": "You prefer to:",
      "subtitle": "Task Management",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Finish one task before starting another",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "Multitask and switch between things",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "Make lists",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "Keep options open",
          "scores": {"P": 1}
        }
      ]
    },
    {
      "question": "Rules are meant to be:",
      "subtitle": "Attitude towards Authority",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Followed strictly",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "Seen as guidelines",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "Respected",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "Challenged",
          "scores": {"P": 1}
        }
      ]
    },
    {
      "question": "You feel more comfortable when:",
      "subtitle": "Certainty vs Ambiguity",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Things are decided",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "Things are open-ended",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "There is a plan",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "There is flexibility",
          "scores": {"P": 1}
        }
      ]
    },
    {
      "question": "Your approach to grocery shopping:",
      "subtitle": "Daily Life",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Strict list, no deviations",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "Decide what looks good at the store",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "Rough ideas of meals",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "Grab random snacks",
          "scores": {"P": 1}
        }
      ]
    },
    {
      "question": "A surprise change in plans:",
      "subtitle": "Adaptability",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Stresses you out",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "Excites you",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "Is annoying but okay",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "Is no big deal",
          "scores": {"P": 1}
        }
      ]
    },
    {
      "question": "You make decisions:",
      "subtitle": "Closure",
      "dimension": "J/P",
      "options": [
        {
          "label": "A",
          "text": "Quickly to settle things",
          "scores": {"J": 2}
        },
        {
          "label": "B",
          "text": "Slowly, keeping options open",
          "scores": {"P": 2}
        },
        {
          "label": "C",
          "text": "Efficiency first",
          "scores": {"J": 1}
        },
        {
          "label": "D",
          "text": "Information gathering first",
          "scores": {"P": 1}
        }
      ]
    },

    // --- Extra Mixture to ensure variety ---
    {
      "question": "In your free time, you prefer:",
      "subtitle": "Lifestyle",
      "dimension": "E/I",
      "options": [
        {
          "label": "A",
          "text": "Hosting a game night",
          "scores": {"E": 2}
        },
        {
          "label": "B",
          "text": "Playing a video game solo",
          "scores": {"I": 2}
        },
        {
          "label": "C",
          "text": "Networking events",
          "scores": {"E": 1}
        },
        {
          "label": "D",
          "text": "Solitary walks",
          "scores": {"I": 1}
        }
      ]
    }
  ];

  static const List<Map<String, dynamic>> interestQuestions = [
    {
      "question": "Choose a weekend activity:",
      "subtitle": "Leisure Preference",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Hiking a new trail",
          "scores": {"Nature": 2, "Active": 1}
        },
        {
          "label": "B",
          "text": "Visiting an art gallery",
          "scores": {"Art": 2, "Creative": 1}
        },
        {
          "label": "C",
          "text": "Coding a side project",
          "scores": {"Tech": 2, "Logic": 1}
        },
        {
          "label": "D",
          "text": "Trying a new restaurant",
          "scores": {"Food": 2, "Social": 1}
        }
      ]
    },
    {
      "question": "Which topic interests you most?",
      "subtitle": "Intellectual Curiosity",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Space and Astronomy",
          "scores": {"Science": 2}
        },
        {
          "label": "B",
          "text": "Psychology and Human Behavior",
          "scores": {"Social": 2}
        },
        {
          "label": "C",
          "text": "History and Politics",
          "scores": {"Humanities": 2}
        },
        {
          "label": "D",
          "text": "Business and Economics",
          "scores": {"Business": 2}
        }
      ]
    },
    {
      "question": "Ideally, your career would involve:",
      "subtitle": "Career Aspiration",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Creating something visually beautiful",
          "scores": {"Art": 2}
        },
        {
          "label": "B",
          "text": "Solving complex logical problems",
          "scores": {"Tech": 2}
        },
        {
          "label": "C",
          "text": "Helping people directly",
          "scores": {"Social": 2}
        },
        {
          "label": "D",
          "text": "Building a company",
          "scores": {"Business": 2}
        }
      ]
    },
    {
      "question": "Pick a movie genre:",
      "subtitle": "Entertainment",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Sci-Fi / Fantasy",
          "scores": {"Creative": 2}
        },
        {
          "label": "B",
          "text": "Documentary",
          "scores": {"Learning": 2}
        },
        {
          "label": "C",
          "text": "Rom-Com",
          "scores": {"Social": 1}
        },
        {
          "label": "D",
          "text": "Action / Thriller",
          "scores": {"Active": 1}
        }
      ]
    },
    {
      "question": "What kind of books do you read?",
      "subtitle": "Reading Habits",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Non-fiction / Self-help",
          "scores": {"Growth": 2}
        },
        {
          "label": "B",
          "text": "Fiction / Novels",
          "scores": {"Creative": 2}
        },
        {
          "label": "C",
          "text": "Biographies",
          "scores": {"Humanities": 1}
        },
        {
          "label": "D",
          "text": "I prefer articles/blogs",
          "scores": {"Tech": 1}
        }
      ]
    },
    {
      "question": "Choose a vacation destination:",
      "subtitle": "Travel Preference",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Relaxing beach resort",
          "scores": {"Chill": 2}
        },
        {
          "label": "B",
          "text": "Bustling city exploration",
          "scores": {"Social": 2}
        },
        {
          "label": "C",
          "text": "Remote cabin in the woods",
          "scores": {"Nature": 2}
        },
        {
          "label": "D",
          "text": "Historical ruins tour",
          "scores": {"Learning": 2}
        }
      ]
    },
    {
      "question": "What defines success for you?",
      "subtitle": "Values",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Financial Freedom",
          "scores": {"Business": 2}
        },
        {
          "label": "B",
          "text": "Making a difference",
          "scores": {"Social": 2}
        },
        {
          "label": "C",
          "text": "Mastering a skill",
          "scores": {"Tech": 2}
        },
        {
          "label": "D",
          "text": "Living authentically",
          "scores": {"Art": 2}
        }
      ]
    },
    {
      "question": "Your dream house would have:",
      "subtitle": "Living Space",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "A massive library",
          "scores": {"Learning": 2}
        },
        {
          "label": "B",
          "text": "A high-tech gaming room",
          "scores": {"Tech": 2}
        },
        {
          "label": "C",
          "text": "A large garden",
          "scores": {"Nature": 2}
        },
        {
          "label": "D",
          "text": "A big kitchen for hosting",
          "scores": {"Social": 2}
        }
      ]
    },
    {
      "question": "If you could learn any skill instantly:",
      "subtitle": "Skill Acquisition",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Painting / Drawing",
          "scores": {"Art": 2}
        },
        {
          "label": "B",
          "text": "Programming",
          "scores": {"Tech": 2}
        },
        {
          "label": "C",
          "text": "Public Speaking",
          "scores": {"Business": 2}
        },
        {
          "label": "D",
          "text": "Survival Skills",
          "scores": {"Nature": 2}
        }
      ]
    },
    {
      "question": "You prefer working:",
      "subtitle": "Work Environment",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Outdoors",
          "scores": {"Nature": 2}
        },
        {
          "label": "B",
          "text": "In a quiet office",
          "scores": {"Tech": 1}
        },
        {
          "label": "C",
          "text": "In a collaborative studio",
          "scores": {"Art": 1}
        },
        {
          "label": "D",
          "text": "From home",
          "scores": {"Chill": 2}
        }
      ]
    },
    {
      "question": "Pick a musical instrument:",
      "subtitle": "Music",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Piano",
          "scores": {"Art": 1, "Classic": 1}
        },
        {
          "label": "B",
          "text": "Electric Guitar",
          "scores": {"Art": 1, "Rock": 1}
        },
        {
          "label": "C",
          "text": "Synthesizer",
          "scores": {"Tech": 1, "Modern": 1}
        },
        {
          "label": "D",
          "text": "Drums",
          "scores": {"Art": 1, "Active": 1}
        }
      ]
    },
    {
      "question": "Favorite type of video game:",
      "subtitle": "Gaming",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "RPG / Story driven",
          "scores": {"Creative": 2}
        },
        {
          "label": "B",
          "text": "Strategy / Puzzle",
          "scores": {"Logic": 2}
        },
        {
          "label": "C",
          "text": "FPS / Action",
          "scores": {"Active": 2}
        },
        {
          "label": "D",
          "text": "Multiplayer / Social",
          "scores": {"Social": 2}
        }
      ]
    },
    // --- Expanded Interest Questions ---
    {
      "question": "Your favorite school subject was:",
      "subtitle": "Education",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Math / Physics",
          "scores": {"Tech": 2}
        },
        {
          "label": "B",
          "text": "Art / Drama",
          "scores": {"Art": 2}
        },
        {
          "label": "C",
          "text": "PE / Sports",
          "scores": {"Active": 2}
        },
        {
          "label": "D",
          "text": "English / Literature",
          "scores": {"Humanities": 2}
        }
      ]
    },
    {
      "question": "You spend most of your money on:",
      "subtitle": "Spending Habits",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Gadgets and gear",
          "scores": {"Tech": 2}
        },
        {
          "label": "B",
          "text": "Experiences and travel",
          "scores": {"Chill": 2}
        },
        {
          "label": "C",
          "text": "Clothes and aesthetics",
          "scores": {"Art": 2}
        },
        {
          "label": "D",
          "text": "Food and drinks",
          "scores": {"Food": 2}
        }
      ]
    },
    {
      "question": "Your favorite social media platform:",
      "subtitle": "Digital Presence",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "LinkedIn / X (Twitter)",
          "scores": {"Business": 2}
        },
        {
          "label": "B",
          "text": "Instagram / Pinterest",
          "scores": {"Art": 2}
        },
        {
          "label": "C",
          "text": "TikTok / YouTube",
          "scores": {"Creative": 1}
        },
        {
          "label": "D",
          "text": "Discord / Reddit",
          "scores": {"Tech": 2}
        }
      ]
    },
    {
      "question": "You want to learn more about:",
      "subtitle": "Curiosity",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "AI and Robotics",
          "scores": {"Tech": 2}
        },
        {
          "label": "B",
          "text": "Philosophy and Ethics",
          "scores": {"Humanities": 2}
        },
        {
          "label": "C",
          "text": "Investing and Finance",
          "scores": {"Business": 2}
        },
        {
          "label": "D",
          "text": "Design and Fashion",
          "scores": {"Art": 2}
        }
      ]
    },
    {
      "question": "Best way to exercise:",
      "subtitle": "Fitness",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Team sports",
          "scores": {"Social": 2}
        },
        {
          "label": "B",
          "text": "Running / Cycling solo",
          "scores": {"Active": 2}
        },
        {
          "label": "C",
          "text": "Yoga / Pilates",
          "scores": {"Chill": 2}
        },
        {
          "label": "D",
          "text": "Lifting weights",
          "scores": {"Active": 1}
        }
      ]
    },
    {
      "question": "You appreciate people who are:",
      "subtitle": "Values II",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Smart and witty",
          "scores": {"Tech": 1}
        },
        {
          "label": "B",
          "text": "Kind and giving",
          "scores": {"Social": 2}
        },
        {
          "label": "C",
          "text": "Creative and unique",
          "scores": {"Art": 2}
        },
        {
          "label": "D",
          "text": "Ambitious and driven",
          "scores": {"Business": 2}
        }
      ]
    },
    {
      "question": "Your coffee order:",
      "subtitle": "Taste",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Black coffee / Espresso",
          "scores": {"NoNonsense": 2}
        },
        {
          "label": "B",
          "text": "Latte with art",
          "scores": {"Art": 1}
        },
        {
          "label": "C",
          "text": "Energy drink instead",
          "scores": {"Tech": 1}
        },
        {
          "label": "D",
          "text": "Herbal tea",
          "scores": {"Chill": 2}
        }
      ]
    },
    {
      "question": "A perfect date involves:",
      "subtitle": "Romance",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Dinner and deep talk",
          "scores": {"Social": 2}
        },
        {
          "label": "B",
          "text": "Activity (Bowling/Mini golf)",
          "scores": {"Active": 2}
        },
        {
          "label": "C",
          "text": "Museum or show",
          "scores": {"Art": 2}
        },
        {
          "label": "D",
          "text": "Cooking together at home",
          "scores": {"Chill": 2}
        }
      ]
    },
    {
      "question": "You follow news about:",
      "subtitle": "News",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Tech releases",
          "scores": {"Tech": 2}
        },
        {
          "label": "B",
          "text": "Stock market",
          "scores": {"Business": 2}
        },
        {
          "label": "C",
          "text": "Celebrity gossip",
          "scores": {"Social": 1}
        },
        {
          "label": "D",
          "text": "Global events",
          "scores": {"Humanities": 1}
        }
      ]
    },
    {
      "question": "Your car choice:",
      "subtitle": "Vehicle",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Tesla / EV",
          "scores": {"Tech": 2}
        },
        {
          "label": "B",
          "text": "Vintage Classic",
          "scores": {"Art": 2}
        },
        {
          "label": "C",
          "text": "Reliable SUV",
          "scores": {"Chill": 1}
        },
        {
          "label": "D",
          "text": "Fast Sports Car",
          "scores": {"Active": 2}
        }
      ]
    },
    {
      "question": "On a rainy day:",
      "subtitle": "Mood",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Productive work session",
          "scores": {"Business": 1}
        },
        {
          "label": "B",
          "text": "Cozy up and sleep",
          "scores": {"Chill": 2}
        },
        {
          "label": "C",
          "text": "Create something",
          "scores": {"Art": 2}
        },
        {
          "label": "D",
          "text": "Game or code",
          "scores": {"Tech": 2}
        }
      ]
    },
    {
      "question": "You admire:",
      "subtitle": "Role Models",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Innovators (Musk/Jobs)",
          "scores": {"Business": 2}
        },
        {
          "label": "B",
          "text": "Artists (Van Gogh/Beyonce)",
          "scores": {"Art": 2}
        },
        {
          "label": "C",
          "text": "Activists (MLK/Malala)",
          "scores": {"Social": 2}
        },
        {
          "label": "D",
          "text": "Scientists (Einstein/Curie)",
          "scores": {"Science": 2}
        }
      ]
    },
    {
      "question": "Best pet:",
      "subtitle": "Animals",
      "dimension": "Interest",
      "options": [
        {
          "label": "A",
          "text": "Dog (Active companion)",
          "scores": {"Active": 2}
        },
        {
          "label": "B",
          "text": "Cat (Chill roommate)",
          "scores": {"Chill": 2}
        },
        {
          "label": "C",
          "text": "Reptile/Fish",
          "scores": {"Science": 1}
        },
        {
          "label": "D",
          "text": "No pets",
          "scores": {"Business": 1}
        }
      ]
    }
  ];
}
