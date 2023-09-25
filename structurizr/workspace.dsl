workspace {

    model {
        clinicUser = person "Clinic" "Clinical user in healthcare"{
            tags = "outofscope"
        }
        citizenUser = person "Citizen" "Citizen person fetching data"{
            tags = "outofscope"
        }
        domainUser = person "Specialist" "Domain specialist"
        developerUser = person "Developer" ""
        platformUser = person "Platform Specialist" "" "Administrator"{
            tags = "outofscope"
        }

        external = softwareSystem  "Some external system" "Doing something fun" {
                tags = "outofscope"
        }

        ent = enterprise "Enterprise" {
            system1 = softwareSystem  "System1" "Create something fun" {
                tags = "outofscope"
            }

            system2 = softwareSystem "System2" "Create something usefull"{
                    tags = "outofscope"
            }
            mainSystem = softwareSystem  "Main System" "Standing on the shoulders of giants" "inscope"{
                mainContainer = container "Main Container" {
                    accountsSummaryController = component "Accounts Summary Controller" "Provides customers with a summary of their bank accounts." "Spring MVC Rest Controller"
                    resetPasswordController = component "Reset Password Controller" "Allows users to reset their passwords with a single use URL." "Spring MVC Rest Controller"
                    securityComponent = component "Security Component" "Provides functionality related to signing in, changing passwords, etc." "Spring Bean"
                    mainFrame = component "Mainframe" "A facade onto the mainframe." "Spring Bean"
                    emailComponent = component "E-mail Component" "Sends e-mails to users." "Spring Bean"
                }
                serverPgpool = container "Server pgpool" {
                        tags "pgPool"
                    }
                serverPg = container "Server Database" {
                        tags "Postgres" "Database"
                        
                    }
                mainContainer -> serverPgpool "Reads from and writes to"
                serverPgpool -> serverPg "Reads from and writes to"

                mainContainer -> system2 "Read&Writes operational templates"
                system1 -> system2 "Read&Writes EHR Forms"
                mainContainer -> external "fetch&commit"

                # relationships to/from components
                accountsSummaryController -> mainFrame "Uses"
                mainFrame -> serverPgpool "Reads from and writes to" "SQL/TCP"
                resetPasswordController -> securityComponent "Uses"
                securityComponent -> serverPgpool "Reads from and writes to" "SQL/TCP"
                emailComponent -> external "Updates repository"
    
            }
            
            domainUser -> mainContainer "Uses"
            developerUser -> mainContainer "Uses"
            clinicUser -> system1 "Uses"
        }

        deploymentEnvironment "Development" {
            deploymentNode "Developer Laptop" "" "Microsoft Windows 10 or Apple macOS" {
                deploymentNode "Docker mainContainer" "" "mainContainer" {
                    developerApplicationInstance = containerInstance mainContainer
                }
                deploymentNode "Docker Container PGPool" "" "Generic PgPool image" {
                    deploymentNode "PgPool" "" "Pooling access to DB" {
                        developerPgPoolApplicationInstance = containerInstance serverPgpool
                    }
                }
                deploymentNode "Docker Container Postgres" "" "postgres:15.4-bullseye" {
                    deploymentNode "Postgres" "" "Database mainContainer" {
                        developerPostgresApplicationInstance = containerInstance serverPg
                    }
                }
            }

        }

        deploymentEnvironment "live" {
            deploymentNode "Kubernetes Cluster" "" "Kubernetes 1.24 or higher" {
                deploymentNode "Deployment Main Application" "" "mainContainer" {
                    deploymentNode "Pod Main Application" "" "mainContainer" "" 3 {
                        liveApplicationInstance = containerInstance mainContainer
                    }
                }
                deploymentNode "Statefulset PgPool" "" "PgPool" {
                    deploymentNode "Pod PgPool" "" "PgPooL" "" 3 {
                        livePgPoolApplicationInstance = containerInstance serverPgpool
                    }
                }
                deploymentNode "Statefulset Postgres" "" "postgres:15.4-bullseye" {
                    deploymentNode "Pod Postgres" "" "Database mainContainer" "" 3 {
                        livePostgresApplicationInstance = containerInstance serverPg
                    }
                }
                deploymentNode "Deployment system1" "" "system1" {
                    deploymentNode "Pod system1" "" "system1" "" 3 {
                        liveStudioInstance = softwareSystemInstance system1
                    }
                }
                deploymentNode "Deployment system2" "" "system2" {
                    deploymentNode "Pod system2" "" "system2" "" 6 {
                        liveEHRInstance = softwareSystemInstance system2
                    }
                }
            }

            deploymentNode "Other Kubernetes Cluster" "" "Kubernetes 1.24 or higher" {
                deploymentNode "Deployment git" "" "mainContainer" {
                    deploymentNode "Pod git" "" "mainContainer" {
                        liveGitInstance = softwareSystemInstance external
                    }
                }
            }


        }




       
        
    }

    views {

        systemLandscape mainSystem "LandScape" {
            include *
            autoLayout
        }

        systemContext mainSystem "SystemContext" {
            include *
            autoLayout
        }

        container mainSystem "ContainerView" {
            include *
            autolayout
        }

        component mainContainer "mainContainer" {
            include *
            autolayout
        }

        deployment mainSystem "Development" "DevelopmentDeployment" {
            include *
            animation {
                developerApplicationInstance
                developerPgPoolApplicationInstance 
                developerPostgresApplicationInstance
            }
            autoLayout
            description "An example development deployment scenario for the Application."
        }

         deployment mainSystem "live" "LiveDeployment" {
            include *
            autoLayout
            description "An example live deployment scenario for the Application."
        }

        styles {
            element "Person" {
                color #ffffff
                fontSize 22
                background #08427b
                shape Person
            }
            element "Component" {
                fontSize 22
                shape Component
            }
            element "inscope" {
                background #08427b
            }
            element "outofscope" {
                background #999999
                color #ffffff
            }
            element "Service API" {
                shape hexagon
            }
            element "Database" {
                shape cylinder
            }
            element "Desktop" {
                background #CACFD2
                shape Window
            }
            
            element "xConnect" {
                background #08827b
            }
            element "idp" {
                background #08480b
            }
            element "Existing System" {
                background #999999
                color #ffffff
            }

            element "Container" {
                background #438dd5
                color #ffffff
            }

            element "Software System" {
                background #555555
                color #ffffff
            }
            element "Administrator"{
                shape "robot"
            }
            
        }


    }

}