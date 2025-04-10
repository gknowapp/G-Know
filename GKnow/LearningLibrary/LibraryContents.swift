//
//  LibraryContents.swift
//  GKnow
//
//  Created by Curt Leonard on 3/18/25.
//

import Foundation

struct LibraryContents {
    
    struct symbolNames {
        
        let male = ["Male", "Male", "A square represents a male on a genogram."]
        let female = ["Female", "Female", "A circle represents a female on a genogram"]
        let abortion = ["Abortion", "Abortion", "Abortion is noted with an X at the end of the dropdown line with neither a circle or square. "]
        let pregancy = ["Pregnancy", "Pregnancy", "A pregnancy is noted on the genogram as a triangle"]
        let miscarriage = ["Miscarriage", "Miscarriage", "Miscarriage is noted with a dot on the end of a drop down line"]

    }
    
    struct relationships  {

         let marriage = ["Marriage Connection", "Marriage", "Marriage is represented by a line that connects two individuals. "]
        let child = ["Child Connection", "Child", "Children are lines that drop vertically from a marriage line. The oldest is listed on the left and birth order decsends as you move to the left."]
        let abuse = ["Abuse", "Abuse", "Abusive relationships often involve a power differential with the person with more power using that to hurt the person with less power. Abuse can also involve chronic  conflict that cannot be reduced or stopped by making requests for change or setting boundaries. In relationships without a power differential (based on age, development, ability or authority) the abuse may be directed at one person or it can involve more than one person in the relationship. Abuse can impact people physically, emotionally and spiritually. The symbol for abuse looks similar to the symbol for conflict but has an arrow that directs away from the perpetrator and toward the one who is being abused."]
        let conflict = ["Conflict", "Conflict", "Conflictual relationships hold chronic tension that often erupts into arguments or through silence/distance. The conflict in the relationship remains unresolved and underlies the overall relationship. As a result, arguments and disagreements may show up with greater frequency and intensity than a non-conflictual relationship. Keep in mind these arguments and conflict can be loud or quiet. Avoidance of a person and the issues that exist with that person can be an indicator of a conflictual relationships as two people who have loud or even physical confrontations. The common theme is the unresolved tension that exists between two people who remain in relationship."]
        let harmony = ["Close", "Harmony", "A close relationships allows individualtiy while also being able to stay calmly connected to each other. There may be times of conflict in the relationship but it is not chronic. A straight line connecting two individuals on a genogram can indicate that they have been able to create this type of close connection overtime and it is important for it to be representing on the genogram."]
        let friendship = ["Friendship", "Friendship", "This connection indicates a friendship between two people"]
        let fusion = ["Fusion", "Fusion", "Fusion locks-down a family's emotional functioning . Members of the family cannot function in a way that repersents their own values, preferences and priorities. Instead, they function as a fused unit that cannot allow for the individuality of each member. The members must base their own functioning on the emotions or reactions of another member of the family. This can look different based on the family dynamics. For example, it can look like not saying things in order to prevent another person from feeling an uncomfortable emotion or saying things repeatedly or forcefully to make sure a person doesn't make a mistake or suffer. This can look like keeping secrets to prevent conflict or it can look like sharing too much information to prevent feelings of being left out."]
        let focus = ["Projection", "Focused On", "TInstead of dealing with issues in their personal lives or in their marriage, parents can sometimes project the unresolved issues or anxiety on to a child in the family by becoming overly focusing on the child. The parent(s) could do this with either positive or negative attention. It can be an over-focus on strengthes, weaknesses, successes or failures, sports, mental health, health, friendships, appearance etc. The line of projection in a genogram is a line with an arrow pointing from the one who projects toward the one who is projected upon."]
        let dating = ["Dating", "Dating", "This indicates that two people are dating"]
        let affair = ["Affair", "Affair", "An affair is noted with a triangle in the space between the two people involved in the affair. "]
        let divorce = ["Divorce", "Divorce", "Divorce is noted by a double slash in the line noting the marriage of 2 people. "]
        
        //case engaged = "Engaged"
        
    }
    
    struct roles {
        
        let hero = ["Hero", "The hero wishes to fix familial issues either by attempting to direct the circumstances of the family through prevention of problems, helping with issues, or distracting from problems through achievement. This sucess can be in school, sports, relationships, professional, community, faith, etc. Acheivement and fixing is the recipe the hero uses to survive the family tension and stressors. When heros are children they are seen as 'mature' or 'responsible' which leads to parents giving increased power and responsibility that may be greater than what is developmentally appropriate. This can have a negative impact in the long-run as it leads to the belief heros have about themselves that they are the ones who are in charge of relationships and cirucumstances that are actually outside of their control. This over-functioning can be percieved as failure and lead to feelings of guilt."]
        
        let peacekeeper = ["Peacekeeper", "The peacekeeper's goal is to establish or maintain a version of 'peace' in the family. This often requires that the peacekeeper avoid the truth, modify the truth, look the other way or 'fix' problems that are not his to fix. The peaceekeeper does this to control the thoughts, feelings and actions of others who may disrupt the 'peace' of the family. look the other way, fix and ask others to do the same (directly or indirectly) in an effort to avoid the conflict or tension that exists in the family. The peacekeeper will request that others in the family the the same either directly (verbal requests or demands) or indirectly (pressure, guilt, facial expressions, etc.)The peacekeeper beleives (rmember this is often not concious, but deeply rooted and unconcious) that the family can’t handle the real truth and that the family will not be able to recover or stay together is they exprience the conflict that would occur if the peacekeeper does not keep the peace.  The sense of 'peace' that the peacekeeper seeks is a false peace and prevents the family from working through necessary conflict to resolve and improve issues in the family. The work of peace keeping takes a significant toll on the peacekeeper and also on other members of the family."]
        
        let lostChild = ["Lost Child", "The lost child deals with the tension in the family by escaping. The lost child wants to avoid dealing with the issues in the family directly and chooses to deal with the tension in the family by finding ways to move away relationally and emotinally (this may or may not include actual physical distance). This act of disappearing may be accomplised through video games, books, sleep, hobbies or relationships outside of the family."]
        
        let scapegoat = ["Scapegoat", "The scapegoat engages with the family  with behavior that family members will turn their attention toward (because they are shocked, worried, angry, disgusted, etc.) and describe as 'wrong' or 'bad'. However, the family often perpetuates the scapegoat’s behavior by providing this negative attention. Scapegoats get attention and stay connected to the family through negative behaviors and the attention they recieve.  As the family attends to the behavior the scapegoats role becomes more entrenched and less likely to moved toward positive behaviors."]
        
        let clown = ["Clown", "The clown responds to the family dynamic by entertaining or distracting. The Clown's goal is to lessen the tension or stress in the family by bringing attention to himself. The challenge with this type of role is that more attention is put on performance to manage how other people think, feel and behave than discovering who the person under the clown mask really is. If the highest priority is decreasing tension through humor or distraction there is not enough value placed defining self and learning how to be authentic in relationships. The Clown may eventually distance from the family in order to discover who he really is in relationships where he can show up without the pressure to distract.  Alternatively, the Clown may stay very connected the family and miss out on discovering who he really is and the family will miss out on knowing the person behind the performance."]
        
        let rebel = ["Rebel", "The rebel will call out what is not right in the family. She may do this by verbalizing her perspetive or just acting in a way that goes against the unspoken (or spoken) rules in the family-especially those that are unjust or misguided. The family responds to the rebel's behavior by trying to get her to fall in line with the expectations of the family. This could include punishing the rebel or it could look like pleading with the rebel to change and go along with the family's norms. The rebel's behavior does not have to be extreme (drugs, partying, being arrested).  Depending on the rules or expectations of the family, rebellion could be attending church or not drinking (if those behaviors go against the predominant 'family rules.') The Rebel lives in a state or reactivity instead of authenticity. Instead of having the chance to understand who she is and represent that in relationships she is consistently reacting to the circumstances around her with her rebellious behavior. She misses out on the chances to decide what matters most to her as a person and bring that into relationships and others miss out on knowing the authentic person under the rebelious behavior."]
        
    }
    
    
}
//
