import gym
from gym import spaces

class ForexEnv(gym.Env):
  """Custom Environment that follows gym interface"""
  metadata = {'render.modes': ['human']}

  def __init__(self, arg1, arg2, ...):
    super(ForexEnv, self).__init__()
    # Define action and observation space
    # They must be gym.spaces objects
    # Example when using discrete actions:
    #self.action_space = spaces.Discrete(N_DISCRETE_ACTIONS)
    # Actions we can take, Sell, Hold, Down
    self.action_space = spaces.Discrete(3)
    # Example for using image as input:
    self.observation_space = spaces.Box(low=0, high=255,
                                        shape=(HEIGHT, WIDTH, N_CHANNELS), dtype=np.uint8)

  def step(self, action):
    
    return observation, reward, done, info
  def reset(self):
    pass
    return observation  # reward, done, info can't be included
  def render(self, mode='human'):
    pass
  def close (self):
    pass