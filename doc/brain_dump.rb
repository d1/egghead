# Well factored
class Event
  # Examples: cut_off_by_driver, see person,
  def initalize type
    @type = type
  end

  def type? other
    type == other
  end

  def type
    @type
  end

  def context #??
    Context.construct_for self
  end
end

class CutOffByDriver < Event; end
class SeePerson      < Event; end


require 'feelings'
require 'actions/*' # Dunno how to do this yet
class Action
  def act
    raise "Not Implemented"
  end

  def appropriate? event
    false
  end

  def self.inheirted klass
    actions << klass.new
  end

  def self.choose_responses_to event
    actions.select {|action| action.appropriate? event }
  end

  private

  def self.actions
    @@actions ||= []
  end
end

require 'body/mouth'
class YellAtDriver < Action
  def act
    Mouth.shout "You &*%#!"
  end

  def appropriate? event
    event.context.include? :driving && Feelings.extremely_angry?
  end
end

require 'body/mouth'
class GrumbleAboutJerk < Action
  def act
    Mounth.grumble "What a jerk"
  end

  def appropriate? event
    Feelings.annoyed? && Feelings.affinity_for event.person, :low
  end
end

class Wave  < Action; end
class Speak < Action; end
class Nod   < Action; end
class Growl < Action; end



class Context < SimpleDelgate
  def intialize(event)
    @event = event
    super(event)
  end

  def applicable_to? event
    false
  end

  # Wraps the event in all the Context 'decorators' available
  def self.contstruct_for event
    ideas.inject(event) do |event, contex|
      if context.applicable_to? event
        context.new event
      else
        event
      end
    end
  end

  private

  def self.inheirted context
    contexts << context.new
  end

  def self.contexts
    @@contexts ||= []
  end
end
# Examples: driving a car, walking, sleeping, late,

include 'body/stomach'
class Hungry < Context
  def applicable_to? event
    Stomach.empty?
  end
end

class DrivingCar < Context
  def applicable_to? event
    $current_actions.include? :driving
  end
end

class Hurry < Context; end



class Perception
  def process event
    @event = event
    interpret
    react
  end

  def interpret
    @interpreted_event = Context.construct_for event
  end

  def react
    responses = Action.choose_responses_to(interpreted_event) # Motiviations?
    responses.each {|action| action.act }
    # -OR-
    $current_actions.add Action.choose_responses_to(interpreted_event)
  end

  private

  attr_reader :event

  def interpreted_event
    @interpreted_event || @event
  end
end

## Some kind of priority queue like thing
# An Actor performs Actions
class Actor
  def add *new_actions
    current_actions + Array(*new_actions)
  end

  def include? action
    current_actions.include? action
  end

  def current_actions
    @current_actions ||= []
  end
end

# EXAMPLE
$current_actions = Actor.new
$current_actions.add DrivingCar.new
$body = Body.new(:stomach => :empty)


event = Event.new :cut_off_by_driver
brain = Perception.new event
bran.process # => "YOU &*%#!"
# END EXAMPLE

##############################################################
# OLD WAY or middle way
# Takes an event and performs the correct action
def react(event)
  case event.type
  when :cut_off_by_driver
    if stewing_on_problem?
      increase_anger 20
    end

    if hungry?
      feelings[:anger] += 10
    end

    if in_a_hurry?
      feelings[:anger] += 50
    else
      feelings[:anger] += 25
    end

    if feelings[:anger] > 60
      yell_at_driver "You &*%#!"
      stew_on event, 15
    else
      grumble_to_self "What a jerk"
      stew_on event, 5
    end
  when :see_person
    if like? event.person
      feelings[:affinity_for][event.person] += 10
    else
      feelings[:affinity_for][event.person] -= 10
    end

    if feelings[:anger] < 25
      if feelings[:affinity_for][event.person] > 20
        wave_to event.person
        say_to event.person, "Hi"
      elsif affinity_for event.person > 10
        wave_to event.person
      elsif recognize? event.person
        nod_to event.person
      end
    elsif feelings[:anger] > 60
      growl_at event.person
    else
      do_nothing
    end
  end
end
