import 'package:flutter/material.dart';
import '../../shared/components/text_button.dart';
import '../../theme/portfolio_theme.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final aboutText = """
I'm Camilo Santacruz Abadiano, a seasoned developer based in Bogotá, Colombia. Since graduating from the Universidad de los Andes and starting my career in 2016, I've had the privilege of working with a diverse range of clients across the United States and Spain. My experience has been a journey of continuous learning, tackling a variety of challenges to deliver high-quality digital solutions. Beyond my professional life, I’m constantly seeking new challenges and experiences, whether it's through physical disciplines like climbing and calisthenics, or exploring new creative outlets. I believe that a blend of technical expertise and creative passion is key to innovative problem-solving.

My interests extend well beyond the code I write. I’m an avid cook who loves a good cup of masala chai, and I'm currently diving into the world of video and image editing to expand my skills in media. Traveling has always been a significant part of my life—I've explored Spain, France, and Australia, and I hope to soon return to my home, Colombia, and visit Japan. In my free time, you'm often find me watching anime or getting lost in a good book, always with music setting the mood. With a working knowledge of Spanish, English, and basic Japanese, I'm excited by the possibilities that new technologies like AI offer for boosting creativity and connecting with people from all over the world.
""";

    return Container(
      height:
          MediaQuery.of(context).size.height +
          MediaQuery.of(context).size.height * 0.2,
      width: double.infinity,
      color: PortfolioTheme.bgColor,
      child: Padding(
        padding: const EdgeInsets.only(top: 200.0, bottom: 100),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: SizedBox(
                    width: 747,
                    height: 474,
                    child: Text(
                      aboutText,
                      style: PortfolioTheme.manropeRegular16.copyWith(
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 17,
                    ),
                  ),
                ),
                CustomTextButton(text: 'Get my CV', onTap: () {}),
                SizedBox(height: 10),
              ],
            ),
            Flexible(
              child: Text('About', style: PortfolioTheme.monotonRegular80),
            ),
          ],
        ),
      ),
    );
  }
}
