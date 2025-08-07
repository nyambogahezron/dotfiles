import React from 'react';
import { Star } from 'lucide-react';

export interface RatingStarsProps {
  rating: number;
  onRatingChange?: (rating: number) => void;
  readonly?: boolean;
  size?: 'small' | 'medium' | 'large' | number;
  maxRating?: number;
  className?: string;
}

export const RatingStars: React.FC<RatingStarsProps> = ({
  rating,
  onRatingChange,
  readonly = false,
  size = 'medium',
  maxRating = 5,
  className = '',
}) => {
  const getStarSize = () => {
    if (typeof size === 'number') {
      return `w-${size} h-${size}`;
    }
    switch (size) {
      case 'small':
        return 'w-3 h-3';
      case 'large':
        return 'w-6 h-6';
      default:
        return 'w-5 h-5';
    }
  };

  const handleClick = (index: number) => {
    if (readonly || !onRatingChange) return;

    const newRating = index + 1;
    // If clicking the same star twice, clear the rating
    if (newRating === rating) {
      onRatingChange(0);
    } else {
      onRatingChange(newRating);
    }
  };

  const handleMouseEnter = (index: number, event: React.MouseEvent) => {
    if (readonly || !onRatingChange) return;

    const stars = event.currentTarget.parentElement?.children;
    if (!stars) return;

    for (let i = 0; i < stars.length; i++) {
      const starEl = stars[i] as HTMLElement;
      if (i <= index) {
        starEl.classList.add('text-yellow-400');
        starEl.classList.remove('text-gray-500');
      } else {
        starEl.classList.remove('text-yellow-400');
        starEl.classList.add('text-gray-500');
      }
    }
  };

  const handleMouseLeave = (event: React.MouseEvent) => {
    if (readonly || !onRatingChange) return;

    const stars = event.currentTarget.parentElement?.children;
    if (!stars) return;

    for (let i = 0; i < stars.length; i++) {
      const starEl = stars[i] as HTMLElement;
      if (i < rating) {
        starEl.classList.add('text-yellow-400');
        starEl.classList.remove('text-gray-500');
      } else {
        starEl.classList.remove('text-yellow-400');
        starEl.classList.add('text-gray-500');
      }
    }
  };

  return (
    <div className={`flex items-center ${className}`}>
      {[...Array(maxRating)].map((_, index) => (
        <Star
          key={index}
          className={`${getStarSize()} ${
            index < rating ? 'text-yellow-400 fill-current' : 'text-gray-500'
          } ${readonly ? 'cursor-default' : 'cursor-pointer'} transition-colors duration-150`}
          onClick={() => handleClick(index)}
          onMouseEnter={readonly ? undefined : (e) => handleMouseEnter(index, e)}
          onMouseLeave={readonly ? undefined : handleMouseLeave}
        />
      ))}
      {!readonly && (
        <span className="ml-2 text-sm text-gray-400">
          {rating > 0 ? `${rating}/${maxRating}` : 'Rate'}
        </span>
      )}
    </div>
  );
};
