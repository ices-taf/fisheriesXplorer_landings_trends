# Prepare data, write CSV data tables

# Before:
# After:

library(icesTAF)

source("utilities.R")
mkdir("data")


################### Getting data from ICES ###################
sid <- icesSD::getSD(NULL, as.numeric(format(Sys.Date(), "%Y")))

fish_category <- dplyr::mutate(sid, X3A_CODE = substr(sid$StockKeyLabel, start = 1, stop = 3))
fish_category <- dplyr::select(fish_category, X3A_CODE, FisheriesGuild)
fish_category$X3A_CODE <- toupper(fish_category$X3A_CODE)
fish_category <- unique(fish_category)
#CAA, SEH, SEZ  have no guild
#REB is both pelagic and demersal
sid$FisheriesGuild[which(sid$StockKeyLabel == "caa.27.5a")] <- "Demersal"
#Should we include seals? maybe not
sid <- sid %>% dplyr::filter(SpeciesScientificName != "Pagophilus groenlandicus")
sid <- sid %>% dplyr::filter(SpeciesScientificName != "Cystophora cristata")


species_list <- load_asfis_species()

hist <- load_historical_catches()
hist$Country[which(hist$Country == "Germany, New L\xe4nder")]<- "Germany"

official <- load_official_catches()

manual_attributions <- readxl::read_excel(
  "./Boot/landings_manual_attributions.xlsx",
  sheet = "current_manual_attributions"
) %>%
  as.data.frame()

## Ceate folders using the acronyms of the ecoregions
for (ecoregion in ecoregions) {
        acronym <- get_ecoregion_acronym(ecoregion)
        mkdir(paste0("./data/", acronym, "/"))

        # if (ecoregion == "Bay of Biscay and the Iberian Coast") {
          catch_dat <- format_catches_dev(
          year = as.numeric(format(Sys.Date(), "%Y")),
          ecoregion = ecoregion,
          historical = hist,
          official = official,
          preliminary = NULL,
          species_list = species_list,
          sid = sid,
          manual_attributions = manual_attributions
        )
        # } else {
        #   catch_dat <- format_catches(as.numeric(format(Sys.Date(), "%Y")), ecoregion, hist, official, NULL, species_list, sid)
        #   catch_dat$COUNTRY[which(catch_dat$COUNTRY == "Russian Federation")] <- "Russia"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic mackerel")] <- "mackerel"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic horse mackerel")] <- "horse mackerel"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic cod")] <- "cod"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic herring")] <- "herring"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "cod")] <- "Demersal"
        # catch_dat$GUILD[which(catch_dat$SPECIES_CODE == "POK")] <- "Demersal"
        # catch_dat$GUILD[which(catch_dat$SPECIES_CODE == "REB")] <- "Demersal"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "European pilchard(=Sardine)")] <- "Sardine"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Scomber mackerels nei")] <- "Mackerels"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Mackerels nei")] <- "Mackerels"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic chub mackerel")] <- "Chub mackerel"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Mackerels")] <- "pelagic"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Chub mackerel")] <- "pelagic"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Jack and horse mackerels nei")] <- "Jack and horse mackerels"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic horse mackerel")] <- "Jack and horse mackerels"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "horse mackerel")] <- "Jack and horse mackerels"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Atlantic mackerel")] <- "mackerel"
        # #adg suggestions 2025
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Angler(=Monk)")] <- "anglerfish"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Anglerfishes NEI")] <- "anglerfish"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Blackbellied angler")] <- "anglerfish"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Monkfishes NEI")] <- "anglerfish"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Monkfishes nei")] <- "anglerfish"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Megrims nei")] <- "megrim"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Megrims NEI")] <- "megrim"

        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Jack and horse mackerels")] <- "pelagic"
        # # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Monkfishes nei")] <- "Anglerfishes nei"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Anglerfishes nei")] <- "benthic"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Pelagic fishes nei")] <- "pelagic"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Raja rays nei")] <- "elasmobranch"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Bathyraja rays nei")] <- "elasmobranch"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Albacore")] <- "pelagic"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Pouting(=Bib)")] <- "demersal"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Gadiformes nei")] <- "demersal"
        # catch_dat$COMMON_NAME[which(catch_dat$COMMON_NAME == "Octopuses, etc. nei")] <- "Octopuses"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Blue mussel")] <- "crustacean"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Sea mussels nei")] <- "crustacean"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Cockles nei")] <- "crustacean"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Common edible cockle")] <- "crustacean"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Tuberculate cockle")] <- "crustacean"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Pouting(=Bib)")] <- "demersal"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Gadiformes nei")] <- "demersal"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Cupped oysters nei")] <- "crustacean"
        # catch_dat$GUILD[which(catch_dat$COMMON_NAME == "Pacific cupped oyster")] <- "crustacean"

        # catch_dat$GUILD <- tolower(catch_dat$GUILD)
        # catch_dat$GUILD[catch_dat$GUILD == "crustacean"] <- "shellfish"
        # }
        
        # catch_dat <- format_catches_dev(
        #   year = as.numeric(format(Sys.Date(), "%Y")),
        #   ecoregion = ecoregion,
        #   historical = hist,
        #   official = official,
        #   preliminary = NULL,
        #   species_list = species_list,
        #   sid = sid,
        #   manual_attributions = manual_attributions
        # )
        
        catch_dat <- unique(catch_dat)
        msg("Saving folder: ", acronym)
        write.taf(catch_dat, file = paste0("catch_dat_", acronym, ".csv"), dir = paste0("./data/", acronym, "/"), quote = TRUE)
}





for (ecoregion in ecoregions) {
  acronym <- get_ecoregion_acronym(ecoregion)
  
  file_path <- paste0("./data/", acronym, "/catch_dat_", acronym, ".csv")
  
  if (file.exists(file_path)) {
    # Read the CSV file
    catch_dat <- read.csv(file_path)
    
    # Assign it to a variable named after the acronym
    assign(acronym, catch_dat)
    
    # Save the data in an .rda file using a structured name
    save(list = acronym, file = paste0("./data/", acronym, ".rda"))
    
    message("Saved: ", acronym)
  } else {
    warning("File not found: ", file_path)
  }
}


