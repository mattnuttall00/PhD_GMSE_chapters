# this is the same as thresh2 but with a manager budget of 5000 and a user budget ranging from 100 to 10,1000


require('GMSE')

UB  <- 100
UBR <- UB/5

thresh4_sim_old <- gmse_apply(
  res_mod = resource,
  obs_mod = observation,
  man_mod = manager,
  use_mod = user,
  get_res = "FUll",
  time_max = 100,
  land_dim_1 = 150,
  land_dim_2 = 150, # landscape is 22,500ha or 22.5km2
  res_movement = 0, # trees don't move 
  remove_pr = 0, # Assume no death 
  lambda = 0, # assume no growth
  agent_view = 150, 
  agent_move = 50, 
  res_birth_K = 1, # must be positive value, but I want it small i.e. no real recruitment
  res_death_K = 5000000, # carrying capacity set to way above starting number of resources
  res_move_type = 0, # 0=no move, 
  res_death_type = 0, # no natural death 
  observe_type = 2, # transect 
  times_observe = 1, 
  obs_move_type = 1, # uniform in any direction
  res_min_age = 0, # age of resources before agents record/act on them
  res_move_obs = FALSE, # trees don't move
  plotting = FALSE, 
  res_consume = 0.08, # Trees have 8% impact on yield
  
  # all genetic algorithm parameters left to default
  
  move_agents = TRUE, 
  max_ages = 1000, 
  minimum_cost = 10, 
  user_budget = UB, 
  manager_budget = 5000, 
  usr_budget_rng = UBR, # introduce variation around the mean user budget (removes step pattern) 
  manage_target = 1125000, 
  RESOURCE_ini = 1125000, 
  culling = TRUE, 
  tend_crops = TRUE,
  tend_crop_yld = 0.01, # tending crops increases yield by 1% - less than that of culling trees
  stakeholders = 20, 
  land_ownership = TRUE, 
  public_land = 0, 
  manage_freq = 1, 
  group_think = FALSE
)

# matrix for results
thresh4 <- matrix(data=NA, nrow=100, ncol=6)

# loop the simulation. 
for(time_step in 1:100){
  
  sim_new <- gmse_apply(get_res = "Full", old_list = thresh4_sim_old, user_budget=UB, usr_budget_rng = UBR)
  
  thresh4[time_step, 1] <- time_step
  thresh4[time_step, 2] <- sim_new$basic_output$resource_results[1]
  thresh4[time_step, 3] <- sim_new$basic_output$observation_results[1]
  thresh4[time_step, 4] <- sim_new$basic_output$manager_results[3]
  thresh4[time_step, 5] <- sum(sim_new$basic_output$user_results[,3])
  thresh4[time_step, 6] <- UB
  
  thresh4_sim_old <- sim_new
  UB <- UB + 100
  UBR <- UB/5
  
}

colnames(thresh4) <- c("Time", "Trees", "Trees_est", "Cull_cost", "Cull_count","User_budget")

thresh4_summary <- data.frame(thresh4)

write.csv(thresh4_summary, file = "outputs/investment/null_scenarios/budget_thresholds/thresh4_summary.csv")