import React, { useState } from 'react';
import { Star } from 'lucide-react';

interface RatingStarsProps {
  rating: number;
  maxRating?: number;
  size?: number;
  readonly?: boolean;
  onRatingChange?: (rating: number) => void;
  className?: string;
}

export const RatingStars: React.FC<RatingStarsProps> = ({
  rating,
  maxRating = 5,
  size = 20,
  readonly = false,
  onRatingChange,
  className = '',
}) => {
  const [hoverRating, setHoverRating] = useState<number | null>(null);

  const handleStarClick = (starIndex: number) => {
    if (!readonly && onRatingChange) {
      onRatingChange(starIndex + 1);
    }
  };

  const handleMouseEnter = (starIndex: number) => {
    if (!readonly) {
      setHoverRating(starIndex + 1);
    }
  };

  const handleMouseLeave = () => {
    if (!readonly) {
      setHoverRating(null);
    }
  };

  const getStarColor = (starIndex: number) => {
    const currentRating = hoverRating !== null ? hoverRating : rating;
    if (starIndex < currentRating) {
      return '#fbbf24'; // Yellow for filled stars
    }
    return '#d1d5db'; // Gray for empty stars
  };

  return (
    <div className={`flex items-center ${className}`} onMouseLeave={handleMouseLeave}>
      {Array.from({ length: maxRating }, (_, index) => (
        <Star
          key={index}
          size={size}
          fill={getStarColor(index)}
          color={getStarColor(index)}
          className={`${
            readonly ? 'cursor-default' : 'cursor-pointer hover:scale-110'
          } transition-transform`}
          onClick={() => handleStarClick(index)}
          onMouseEnter={() => handleMouseEnter(index)}
        />
      ))}
    </div>
  );
};
