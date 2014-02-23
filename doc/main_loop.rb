

# Some kind of loop that pulls actions off a queue or deals with threads or something.
#   Want to show that when the loop is only pulling data from the 'senses' queue that it is happier or more peaceful.
#   When it has to pull a lot from the 'mental activities' queue, those things start spawning things that make it have to pull from the 'mental activities' queue even more.
#   The queue manager should keep stats of what is being pulled off so we can display them. E.g. percent of time spent in "Craving".

class Consciousness
  def initalize(senses)
    @senses = senses
  end

  def run
    perception = Perception.new

    loop do
      event = senses.next_event # Pulls from the 'senses' queue
      perception.process event # Puts an action on the 'subconscious' queue
    end
  end

  private
  attr_reader :senses
end

class SubConsciousness


  # Spawn a thread that creates a queue, then monitors it,
  # Adding stuff based on what it finds
  def run
    loop

  end

end




# require 'mind/memory'
# require 'mind/senses'
# require 'mind/sub_consciousness'
# require 'mind/consciousness'
class Mind
  def intialize
    @memory          = Memory.new # Storage
    @attention       = Attention.new # Picks between two events or actions
    @perception      = Perception.new # Interprets events
    @language        = Language.new # ?Looks for patterns?
    @metacognition   = Metacognition.new # Keeps stats on running activities
    @subconsiousness = SubConsciousness.new # Responds to events with activities
    @consiousness    = Consciousness.new # Responds to events with actions
  end

  def start
    start_subconsiousness
    start_basic_mental_processes
    start_consiousness
  end

  def start_basic_mental_processes
    attention.start
    memory.start
    perception.start
    language.start
    metacognition.start
  end

  def start_subconsiousness
    subconsiousness.run
  end

  private
  attr_reader :consciousness, :subconsciousness, :senses
end
